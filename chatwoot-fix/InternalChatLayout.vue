<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue';
import { useMapGetter } from 'dashboard/composables/store';
import { useStore } from 'dashboard/composables/store';
import { useAlert } from 'dashboard/composables';
import Avatar from 'next/avatar/Avatar.vue';
import Icon from 'next/icon/Icon.vue';
import NextButton from 'next/button/Button.vue';

const accountId = useMapGetter('getCurrentAccountId');
const currentUser = useMapGetter('getCurrentUser');
const store = useStore();

const conversations = ref([]);
const messages = ref([]);
const msgContainer = ref(null);
let stickToBottom = true; // começa "grudado" embaixo; desgruda se usuário rolar para cima
const currentConv = ref(null);
const users = ref([]);
const newMsg = ref('');
const showPicker = ref(false);
const selected = ref([]);
const editingId = ref(null);
const editContent = ref('');
const pastedFiles = ref([]); // arquivos colados via Ctrl+V (imagens)
const msgInput = ref(null); // textarea da caixa de texto (para auto-grow)
let lastSentAt = 0; // timestamp do último envio — segura o scroll no fundo logo após enviar
const pendingLocal = ref([]); // mensagens recém-enviadas ainda não confirmadas pelo polling
let timer = null;
let unreadTimer = null;

const BASE = computed(() => `/api/v1/accounts/${accountId.value}/internal_chat`);

const updateUnreadCount = async () => {
  try { await store.dispatch('internalChat/getUnreadCount'); } catch(e) {}
};

const markRead = async () => {
  try { await store.dispatch('internalChat/markRead'); } catch(e) {}
};

onMounted(async () => {
  document.addEventListener('paste', onPaste);
  await loadConvs();
  await axios.get(BASE.value + '/users').then(r => users.value = r.data || []).catch(() => {});
  await markRead();
  await updateUnreadCount();
  timer = setInterval(() => { loadConvs(); if (currentConv.value) loadMsgs(currentConv.value.id); }, 3000);
  unreadTimer = setInterval(() => updateUnreadCount(), 10000);
});

onUnmounted(() => {
  document.removeEventListener('paste', onPaste);
  clearInterval(timer);
  clearInterval(unreadTimer);
});

const loadConvs = async () => {
  try { const r = await axios.get(BASE.value); conversations.value = r.data || []; } catch(e) {}
};

const scrollToBottom = async (smooth = false) => {
  await nextTick();
  const el = msgContainer.value;
  if (!el) return;
  el.scrollTo({ top: el.scrollHeight, behavior: smooth ? 'smooth' : 'auto' });
};

// Ajusta a altura da textarea conforme o conteúdo (com limite).
const autoGrow = () => {
  const el = msgInput.value;
  if (!el) return;
  el.style.height = 'auto';
  el.style.height = Math.min(el.scrollHeight, 96) + 'px';
};

// Ordena as mensagens em ordem de exibição (antiga → nova), independente da
// ordem que o servidor devolver.
const sortMsgs = arr => arr.slice().sort((a, b) => (a.created_at || 0) - (b.created_at || 0));

// Cola imagem com Ctrl+V (como no chat com cliente): lê arquivos do clipboard e
// adiciona como anexo pendente (preview acima do input).
const onPaste = e => {
  if (!currentConv.value) return;
  const files = Array.from(e.clipboardData?.files || []).filter(f => f.size > 0);
  if (!files.length) return;
  e.preventDefault();
  files.forEach(file => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onloadend = () => {
      pastedFiles.value.push({ file, thumb: reader.result });
    };
  });
};

const removePasted = idx => {
  pastedFiles.value.splice(idx, 1);
};

const onScroll = () => {
  const el = msgContainer.value;
  if (!el) return;
  // desgruda do fundo quando o usuário rola para cima (como o WhatsApp)
  stickToBottom = el.scrollTop + el.clientHeight >= el.scrollHeight - 60;
};

const loadMsgs = async id => {
  try {
    const r = await axios.get(`${BASE.value}/${id}/messages`);
    let next = Array.isArray(r.data) ? r.data : [];
    // Anti-"mensagem some": se uma mensagem que acabamos de enviar ainda não
    // veio na resposta do servidor, mantemos ela na lista (nunca some da tela).
    if (pendingLocal.value.length) {
      const ids = new Set(next.map(m => m.id));
      pendingLocal.value.forEach(m => {
        if (m.id != null && !ids.has(m.id) && !m.deleted) next.push(m);
      });
      pendingLocal.value = pendingLocal.value.filter(
        m => ids.has(m.id) && !m.deleted
      );
    }
    messages.value = sortMsgs(next);
    // Garante que a última mensagem fica visível: quando estamos "grudados" no
    // fundo OU logo após enviar, rola até o fim (a mensagem nova fica no fim).
    if (stickToBottom || Date.now() - lastSentAt < 5000) await scrollToBottom();
  } catch(e) {}
};

const openConv = async conv => {
  currentConv.value = conv;
  stickToBottom = true;
  await loadMsgs(conv.id);
  await markRead();
  await updateUnreadCount();
  try { await axios.post(`${BASE.value}/${conv.id}/read_conversation`); } catch(e) {}
};

const fileInput = ref(null);
const sending = ref(false);
const canSend = computed(() => !!(newMsg.value.trim() || pastedFiles.value.length));

const sendMsg = async () => {
  const fileList = [...(fileInput.value?.files || [])];
  if ((!newMsg.value.trim() && !fileList.length && !pastedFiles.value.length) || !currentConv.value || sending.value) return;
  sending.value = true;
  try {
    const formData = new FormData();
    if (newMsg.value.trim()) formData.append('content', newMsg.value.trim());
    for (const f of fileList) formData.append('attachments[]', f);
    pastedFiles.value.forEach(pf => formData.append('attachments[]', pf.file));
    const r = await axios.post(`${BASE.value}/${currentConv.value.id}/create_message`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    });
    messages.value = sortMsgs([...messages.value, r.data]);
    pendingLocal.value.push(r.data); // acompanha até o servidor confirmar
    lastSentAt = Date.now();
    stickToBottom = true;
    await scrollToBottom();
    // Re-pin logo depois: se a mensagem ficou fora do viewport (ou a animação
    // suave parou antes), garante que ela entre na área visível.
    setTimeout(() => { stickToBottom = true; scrollToBottom(true); }, 120);
    newMsg.value = '';
    pastedFiles.value = [];
    if (fileInput.value) fileInput.value.value = '';
    await nextTick();
    autoGrow();
  } catch(e) { useAlert('Erro ao enviar'); }
  finally { sending.value = false; }
};

const triggerFile = () => fileInput.value?.click();

const isImage = name => /\.(jpg|jpeg|png|gif|webp|svg)$/i.test(name);

const startEdit = msg => { editingId.value = msg.id; editContent.value = msg.content; };
const saveEdit = async msg => {
  try {
    const r = await axios.put(`${BASE.value}/${currentConv.value.id}/update_message`, { message_id: msg.id, content: editContent.value });
    const idx = messages.value.findIndex(m => m.id === msg.id);
    if (idx !== -1) messages.value[idx] = r.data;
    editingId.value = null;
  } catch(e) { useAlert(e.response?.data?.error || 'Erro ao editar'); }
};

const deleteMsg = async msg => {
  try {
    await axios.delete(`${BASE.value}/${currentConv.value.id}/destroy_message`, { data: { message_id: msg.id } });
    const idx = messages.value.findIndex(m => m.id === msg.id);
    if (idx !== -1) messages.value[idx] = { ...messages.value[idx], content: 'Mensagem apagada', deleted: true };
  } catch(e) { useAlert(e.response?.data?.error || 'Erro ao excluir'); }
};

const toggleUser = id => {
  const idx = selected.value.indexOf(id);
  idx > -1 ? selected.value.splice(idx, 1) : selected.value.push(id);
};

const createConv = async () => {
  if (!selected.value.length) return useAlert('Selecione ao menos um usuário');
  try {
    const r = await axios.post(BASE.value, { message: 'Início da conversa interna', user_ids: selected.value });
    showPicker.value = false; selected.value = [];
    conversations.value.unshift(r.data);
    openConv(r.data);
  } catch(e) { useAlert('Erro ao criar conversa'); }
};

const convName = computed(() => {
  if (!currentConv.value) return '';
  const parts = (currentConv.value.participants || []).filter(p => p.id !== currentUser.value?.id);
  if (!parts.length) return 'Chat Interno';
  return parts.map(p => p.name).join(', ');
});

const fmtTime = ts => ts ? new Date(ts * 1000).toLocaleString('pt-BR', { day: '2-digit', month: '2-digit', hour: '2-digit', minute: '2-digit' }) : '';
const fmtHour = ts => ts ? new Date(ts * 1000).toLocaleString('pt-BR', { hour: '2-digit', minute: '2-digit' }) : '';
const canEdit = msg => !msg.deleted && (Date.now()/1000 - msg.created_at) < 900 && msg.sender?.id === currentUser.value?.id;
const canDelete = msg => !msg.deleted && (Date.now()/1000 - msg.created_at) < 900 && msg.sender?.id === currentUser.value?.id;
const listName = conv => (conv.participants || []).filter(p => p.id !== currentUser.value?.id).map(p => p.name.split(' ')[0]).join(', ') || 'Chat Interno';
</script>

<template>
  <div class="flex flex-1 h-full w-full overflow-hidden bg-n-background">
    <!-- LEFT PANEL: igual à lista de conversas normal -->
    <div class="w-80 2xl:w-96 flex-shrink-0 border-r border-n-slate-3 flex flex-col bg-n-surface-1">
      <div class="px-3 py-3 border-b border-n-slate-3 flex items-center justify-between min-h-[49px]">
        <h2 class="text-sm font-semibold text-n-slate-12">Chat Interno</h2>
        <button class="flex items-center justify-center size-8 rounded-lg hover:bg-n-alpha-2 text-n-slate-11 transition-colors" @click="showPicker = true">
          <fluent-icon icon="add" size="18" />
        </button>
      </div>
      <div class="flex-1 overflow-y-auto conversations-list">
        <div v-for="conv in conversations" :key="conv.id"
          class="relative flex items-start flex-grow-0 flex-shrink-0 w-auto max-w-full py-3 cursor-pointer conversation border-b border-n-slate-3 hover:bg-n-alpha-1 px-3"
          :class="{ 'bg-n-alpha-2 !border-n-slate-4': currentConv?.id === conv.id }"
          @click="openConv(conv)">
          <div class="flex-shrink-0 flex -space-x-1 mt-0.5 ltr:mr-3 rtl:ml-3">
            <template v-for="(p, idx) in (conv.participants || []).filter(p => p.id !== currentUser?.id).slice(0, 3)" :key="p.id">
              <Avatar :name="p.name" :src="p.avatar_url" :size="32" class="border-2 border-n-surface-1 rounded-full" :style="{ zIndex: 3 - idx }" />
            </template>
          </div>
          <div class="min-w-0 flex-1">
            <h4 class="text-sm my-0 capitalize pt-0.5 text-ellipsis overflow-hidden whitespace-nowrap flex-1 min-w-0 text-n-slate-12 font-semibold">
              {{ listName(conv) }}
            </h4>
            <p v-if="conv.last_message" class="text-sm my-0 leading-6 h-6 flex-1 min-w-0 overflow-hidden text-ellipsis whitespace-nowrap text-n-slate-11">
              {{ conv.last_message.deleted ? 'Mensagem apagada' : conv.last_message.content }}
            </p>
          </div>
          <div class="absolute flex flex-col ltr:right-3 rtl:left-3 top-3 items-end">
            <span class="ml-auto font-normal leading-4 text-xxs text-n-slate-10">{{ fmtTime(conv.last_activity_at) }}</span>
          </div>
        </div>
        <div v-if="!conversations.length" class="p-6 text-center text-sm text-n-slate-10">Nenhuma conversa ainda.</div>
      </div>
    </div>

    <!-- RIGHT PANEL: visualização da conversa -->
    <div class="flex-1 flex flex-col min-w-0">
      <div v-if="currentConv" class="px-4 py-3 border-b border-n-slate-3 bg-n-surface-1 flex items-center gap-2">
        <div class="flex -space-x-1">
          <template v-for="(p, idx) in (currentConv.participants || []).slice(0, 3)" :key="p.id">
            <Avatar :name="p.name" :src="p.avatar_url" :size="28" class="border-2 border-n-surface-1 rounded-full" :style="{ zIndex: 3 - idx }" />
          </template>
        </div>
        <div class="min-w-0 flex-1">
          <h3 class="text-sm font-semibold text-n-slate-12 truncate">{{ convName }}</h3>
          <p v-if="(currentConv.participants || []).length > 2" class="text-xs text-n-slate-10 truncate">
            {{ (currentConv.participants || []).filter(p => p.id !== currentUser?.id).length }} participantes
          </p>
        </div>
      </div>

      <div v-if="currentConv" ref="msgContainer" class="flex-1 overflow-y-auto px-4 py-4 space-y-2" @scroll="onScroll">
        <div v-for="msg in messages" :key="msg.id" class="flex w-full mb-2" :class="msg.sender?.id === currentUser?.id ? 'justify-end' : 'justify-start'">
          <!-- Avatar lateral (igual à conversa com cliente) -->
          <div v-if="msg.sender?.id !== currentUser?.id" class="flex items-end shrink-0 ltr:mr-2 rtl:ml-2">
            <Avatar :name="msg.sender?.name" :src="msg.sender?.avatar_url" :size="24" class="rounded-full" />
          </div>
          <div class="group flex flex-col min-w-0" :class="msg.sender?.id === currentUser?.id ? 'items-end' : 'items-start'">
            <div v-if="msg.sender?.id !== currentUser?.id && !msg.deleted" class="text-xs text-n-slate-10 mb-1 ltr:ml-1 rtl:mr-1">{{ msg.sender?.name }}</div>
            <!-- Bubble com hover group (mesmo visual do chat do cliente) -->
            <div class="relative max-w-xs lg:max-w-md xl:max-w-lg rounded-xl px-3 py-2 text-sm leading-5 break-words"
              :class="msg.sender?.id === currentUser?.id
                ? 'right-bubble ltr:rounded-br-sm rtl:rounded-bl-sm bg-n-solid-blue text-n-slate-12'
                : 'left-bubble ltr:rounded-bl-sm rtl:rounded-br-sm bg-n-slate-4 text-n-slate-12'"
              @click.right.prevent="msg.sender?.id === currentUser?.id && !msg.deleted ? (canEdit(msg) ? startEdit(msg) : null) : null">
              <!-- Edit mode -->
              <div v-if="editingId === msg.id">
                <textarea v-model="editContent" class="w-full bg-transparent border rounded p-1 text-sm outline-none resize-none"
                  :class="msg.sender?.id === currentUser?.id ? 'text-n-slate-12 border-n-slate-5' : 'text-n-slate-12 border-n-slate-5'" rows="2"/>
                <div class="flex gap-2 justify-end text-xs mt-1">
                  <button class="underline opacity-70 hover:opacity-100" @click="saveEdit(msg)">Salvar</button>
                  <button class="underline opacity-70 hover:opacity-100" @click="editingId = null">Cancelar</button>
                </div>
              </div>
              <!-- Normal message -->
              <div v-else>
                <span v-if="msg.deleted" class="italic opacity-60">Mensagem apagada</span>
                <div v-else>
                  <span>{{ msg.content }}</span>
                  <div v-if="msg.attachments?.length" class="mt-1 flex flex-wrap gap-1">
                    <template v-for="att in msg.attachments" :key="att.id">
                      <a v-if="isImage(att.file_name)" :href="att.file_url" target="_blank" class="block">
                        <img :src="att.file_url" class="max-w-[200px] max-h-[150px] rounded-lg object-cover" />
                      </a>
                      <a v-else :href="att.file_url" target="_blank"
                        class="flex items-center gap-1 px-2 py-1 rounded bg-black/10 text-xs">
                        <fluent-icon icon="attach" size="12" /> {{ att.file_name }}
                      </a>
                    </template>
                  </div>
                </div>
              </div>
              <!-- Footer: hora + editar/excluir no hover + status entregue/lido (igual WhatsApp) -->
              <div v-if="editingId !== msg.id" class="flex items-center gap-1 mt-1" :class="msg.sender?.id === currentUser?.id ? 'justify-end' : 'justify-start'">
                <span class="text-xxs text-n-slate-10">
                  {{ fmtHour(msg.created_at) }}
                  <span v-if="msg.edited" class="ml-0.5">(editada)</span>
                </span>
                <!-- Status entregue/lido: dois checks cinza (entregue) ou azul (lido) -->
                <span v-if="msg.sender?.id === currentUser?.id && !msg.deleted && msg.read_by" class="ml-0.5">
                  <Icon
                    v-tooltip.top-start="msg.read_by.length > 0 ? 'Lida' : 'Entregue'"
                    icon="i-lucide-check-check"
                    :class="msg.read_by.length > 0 ? 'text-[#7EB6FF]' : 'text-n-slate-10'"
                    class="size-[14px]"
                  />
                </span>
              </div>
            </div>
            <!-- Edit/Delete buttons: visíveis no hover, abaixo da bolha -->
            <div v-if="msg.sender?.id === currentUser?.id && !msg.deleted" class="flex gap-2 text-xxs opacity-0 group-hover:opacity-100 transition-opacity mt-0.5 ltr:mr-1 rtl:ml-1">
              <button v-if="canEdit(msg)" class="underline text-n-slate-10 hover:text-n-slate-12" @click.stop="startEdit(msg)">editar</button>
              <button v-if="canDelete(msg)" class="underline text-n-slate-10 hover:text-n-slate-12" @click.stop="deleteMsg(msg)">excluir</button>
            </div>
          </div>
          <div v-if="msg.sender?.id === currentUser?.id" class="flex items-end shrink-0 ltr:ml-2 rtl:mr-2">
            <Avatar :name="currentUser?.name" :src="currentUser?.avatar_url" :size="24" class="rounded-full" />
          </div>
        </div>
      </div>

      <div v-else class="flex-1 flex flex-col items-center justify-center gap-1 text-sm text-n-slate-10">
        <fluent-icon icon="chat" size="40" class="text-n-slate-8" />
        <p>Selecione uma conversa ou clique em <strong>+</strong> para iniciar</p>
      </div>

      <div v-if="currentConv" class="px-3 py-3 border-t border-n-slate-3 bg-n-surface-1">
        <!-- Caixa de texto igual à do chat com cliente (ReplyBox) -->
        <div class="relative border border-n-weak rounded-xl bg-n-solid-1 focus-within:border-woot-400 transition-colors">
          <!-- Preview dos arquivos colados via Ctrl+V -->
          <div v-if="pastedFiles.length" class="flex flex-wrap gap-2 px-3 pt-3">
            <div v-for="(pf, idx) in pastedFiles" :key="idx" class="relative">
              <img :src="pf.thumb" class="size-16 object-cover rounded-lg border border-n-slate-4" />
              <button
                class="absolute -top-1.5 -right-1.5 size-5 rounded-full bg-n-slate-12 text-white text-xs flex items-center justify-center hover:bg-n-ruby-9"
                @click="removePasted(idx)"
              >×</button>
            </div>
          </div>
          <!-- Editor -->
          <div class="px-3 pt-2 pb-1">
            <textarea ref="msgInput" v-model="newMsg" rows="1" class="w-full bg-transparent text-sm text-n-slate-12 outline-none resize-none max-h-24 placeholder-n-slate-9"
              placeholder="Digite sua mensagem..." @input="autoGrow" @keyup.enter.exact="sendMsg" @keydown.enter.exact.prevent/>
          </div>
          <!-- Painel inferior: anexar + enviar -->
          <div class="flex items-center justify-between px-2 pb-2">
            <div class="flex items-center gap-1">
              <NextButton v-tooltip.top-end="'Anexar arquivo'" icon="i-ph-paperclip" slate faded sm @click="triggerFile" />
              <input ref="fileInput" type="file" multiple class="hidden" @change="sendMsg" />
            </div>
            <NextButton label="Enviar (↵)" color="blue" sm type="submit" :disabled="!canSend" @click="sendMsg" />
          </div>
        </div>
      </div>
    </div>

    <!-- User Picker Modal -->
    <div v-if="showPicker" class="fixed inset-0 z-50 flex items-center justify-center bg-black/50" @click.self="showPicker = false">
      <div class="bg-n-surface-1 rounded-xl shadow-xl w-96 flex flex-col" style="max-height: 80vh;">
        <div class="flex-shrink-0 px-6 pt-6 pb-2 flex items-center justify-between">
          <h3 class="text-base font-semibold text-n-slate-12">Nova Conversa</h3>
          <button class="size-6 flex items-center justify-center rounded hover:bg-n-alpha-2 text-n-slate-11" @click="showPicker = false">
            <fluent-icon icon="dismiss" size="16" />
          </button>
        </div>
        <div class="flex-1 overflow-y-auto px-6 space-y-0.5 min-h-0">
          <div v-for="u in users.filter(x => !x.has_open_chat)" :key="u.id"
            class="flex items-center gap-3 px-2 py-2 rounded-lg cursor-pointer hover:bg-n-alpha-1 transition-colors"
            :class="{ 'bg-n-alpha-2': selected.includes(u.id) }" @click="toggleUser(u.id)">
            <input type="checkbox" :checked="selected.includes(u.id)" class="rounded border-n-slate-5 text-woot-500" />
            <Avatar :name="u.name" :src="u.avatar_url" :size="28" />
            <div class="min-w-0">
              <p class="text-sm font-medium text-n-slate-12 truncate">{{ u.name }}</p>
              <p class="text-xs text-n-slate-10 truncate">{{ u.email }}</p>
            </div>
          </div>
          <div v-if="!users.filter(x => !x.has_open_chat).length" class="py-4 text-center text-sm text-n-slate-10">Todos os usuários já têm conversa aberta</div>
        </div>
        <div class="flex-shrink-0 flex justify-end gap-2 px-6 py-4 border-t border-n-slate-3">
          <button class="px-3 py-1.5 text-sm font-medium text-n-slate-11 hover:bg-n-alpha-2 rounded-lg transition-colors" @click="showPicker = false">Cancelar</button>
          <button class="px-3 py-1.5 text-sm font-medium bg-woot-500 text-white rounded-lg hover:bg-woot-600 transition-colors" @click="createConv">Iniciar</button>
        </div>
      </div>
    </div>
  </div>
</template>
