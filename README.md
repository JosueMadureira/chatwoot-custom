# Chatwoot Custom

**Versão customizada do Chatwoot com melhorias focadas na experiência do agente.**

[![Docker Pulls](https://img.shields.io/docker/pulls/josemadureira/chatwoot-custom)](https://hub.docker.com/r/josemadureira/chatwoot-custom)

---

## 📌 Imagens Docker disponíveis

| Imagem | Descrição |
|---|---|
| `josuemadureira/chatwoot-custom:v4.15.0` | **Atual + EM PRODUÇÃO** (deploy 2026-08-03) — v4.14.9 + melhoria da edição (foco/Enter/Esc/botões, sem conflito com duplo clique e corretor) + **duplo clique responde no chat do cliente** |
| `josuemadureira/chatwoot-custom:v4.14.9` | v4.14.8 + feature **Responder** no Chat Interno (botão direito + duplo clique, citação na bolha) + fix do bug que zerava a lista (serialize usava `@conversation` nil no `index`) |
| `josuemadureira/chatwoot-custom:v4.14.8` | v4.14.7 + ROOT CAUSE do "msg some em conversa de 2 pessoas" (default_scope do Message anulava o `.order` → fix `.reorder`) |
| `josuemadureira/chatwoot-custom:v4.14.7` | v4.14.6 + menu de contexto (botão direito) Editar/Excluir igual ao chat com cliente |
| `josuemadureira/chatwoot-custom:v4.14.6` | v4.14.5 + correção da ORDEM das mensagens (antiga→nova) |
| `josuemadureira/chatwoot-custom:v4.14.5` | v4.14.4 + fix do bug da mensagem que sumia (scroll robusto + merge safeguard) + caixa de texto nova (igual ao ReplyBox do cliente) |
| `josuemadureira/chatwoot-custom:v4.14.4` | v4.14.3 + melhorias visuais do Chat Interno (balões/avatares iguais ao cliente, checks ✓✓ entregue/lido, colar imagem com Ctrl+V) |
| `josuemadureira/chatwoot-custom:v4.14.3` | v4.14.2 + correção dos 3 bugs do Chat Interno |
| `josuemadureira/chatwoot-custom:v4.14.2` | Produção em uso até 2026-08-02 (sem as correções) — base dos overlays |
| `josuemadureira/chatwoot-custom:v1.2` | Versão antiga (Notificações Inteligentes) |

```bash
# Baixar a imagem atual
docker pull josuemadureira/chatwoot-custom:v4.15.0
```

---

## ✨ Funcionalidades Implementadas

### v4.14.3 – Correção dos bugs do Chat Interno (2026-08-02)

**Base:** `josuemadureira/chatwoot-custom:v4.14.2` (NÃO é um build novo — é um overlay que só acrescenta os arquivos corrigidos por cima da base, sem tocar no banco).

Três bugs foram corrigidos:

#### 🐛 Bug 1 — Mensagem some no Chat Interno (só aparece na notificação)
- **Sintoma:** em conversas internas com mais de 100 mensagens, as novas mensagens não aparecem no chat — só chegam via notificação.
- **Causa:** a action `messages` usava `.order(created_at: :asc).limit(100)` → retornava as **100 mensagens mais antigas**, escondendo as novas.
- **Correção final (v4.14.8):** subquery `latest_ids` busca os ids das **100 mais recentes** e devolve em ordem de exibição (antiga → nova). **Dois ajustes obrigatórios:**
  1. **v4.14.6** — `.order(created_at: :desc).limit(100).pluck(:id)`: usar subquery `latest_ids` + re-ordenar `asc` (o `.reverse` num `ActiveRecord::Relation` é no-op).
  2. **v4.14.8** — trocar `.order` por **`.reorder`** no `latest_ids`: o model `Message` tem `default_scope { order(created_at: :asc) }`, que **anulava** o `.order(created_at: :desc)` (em Rails, `order()` acrescenta, não substitui) e fazia o `limit(100)` voltar a retornar as 100 **mais antigas** — por isso o bug reaparecia em conversas >100 msgs (a de 2 pessoas).
- ⚠️ **Lições:** (1) **NUNCA** usar `.reverse` em query de controller (no-op); (2) se o model tiver `default_scope` de ordenação, **usar `.reorder`, nunca `.order`**.
- **Arquivo:** `chatwoot-fix/internal_chat_controller.rb`

#### 🐛 Bug 2 — Preferência de notificação re-marca sozinha (enche o e-mail)
- **Sintoma:** a preferência "Uma nova mensagem foi criada e atribuída" voltava a ficar marcada sozinha a cada mensagem interna, gerando enxurrada de e-mails.
- **Causa:** o `broadcast_message` **forçava** `email_assigned_conversation_new_message = true` e `push_assigned_conversation_new_message = true` para todos os participantes a cada mensagem — o único lugar no código que setava essa flag.
- **Correção:** removido o bloco que forçava as flags; **mantida** a criação da `Notification` (o sino continua funcionando). O envio de e-mail/push passa a respeitar a preferência de cada usuário.
- **Arquivo:** `chatwoot-fix/internal_chat_controller.rb`

#### 🐛 Bug 3 — Chat Interno abre na primeira mensagem (deveria abrir embaixo, como o WhatsApp)
- **Sintoma:** ao abrir uma conversa, o chat rolava para cima (na 1ª mensagem) em vez de abrir na última.
- **Causa:** o `InternalChatLayout.vue` não tinha nenhuma lógica de scroll.
- **Correção:** adicionada lógica `scrollToBottom` (via `nextTick` + `scrollTo`) com comportamento "grudar no fundo": abre na última mensagem, desgruda se o usuário rolar para cima e volta a grudar ao enviar/receber mensagem — igual ao WhatsApp.
- **Arquivo:** `chatwoot-fix/InternalChatLayout.vue`

### v4.14.4 – Melhorias visuais do Chat Interno (2026-08-02)

**Base:** `josuemadureira/chatwoot-custom:v4.14.3`. Apenas o frontend mudou (`InternalChatLayout.vue` + assets Vite recompilados).

- 🎨 **Balões iguais aos do chat com cliente** — mesmas cores (`bg-n-solid-blue` para o agente, `bg-n-slate-4` para os demais) e cantos arredondados `rounded-xl` com `rounded-br-sm`/`rounded-bl-sm`, replicando o `BaseBubble` da conversa normal.
- 👤 **Avatar lateral** em cada mensagem (de quem enviou à esquerda, do agente atual à direita), como na conversa com cliente.
- ✅ **Checks de entregue/lido iguais ao WhatsApp** — dois checks cinza (`i-lucide-check-check` + `text-n-slate-10`) = entregue; dois checks azuis (`text-[#7EB6FF]`) = lido (quando o destinatário abriu a conversa). Antes era `✓`/`✓✓` simples.
- 📋 **Colar imagem com Ctrl+V** — agora funciona como no chat do cliente: cole um print/arquivo de imagem direto no input, aparece o preview acima do campo, e envia junto com o texto (ou sozinho). Continua funcionando o botão de clip (upload de arquivo).
- **Arquivo:** `chatwoot-fix/InternalChatLayout.vue`

### v4.14.5 – Fix do bug "mensagem some" + caixa de texto nova (2026-08-02)

**Base:** `josuemadureira/chatwoot-custom:v4.14.4`. Só o frontend mudou (`InternalChatLayout.vue` + assets Vite recompilados).

- 🐛 **Bug da mensagem que sumia ~3s** — o polling de 3s substituía a lista inteira e, se o `stickToBottom` estivesse `false` no meio, a mensagem nova (no fim da lista) saía da área visível → "sumia". Correção em 2 frentes no `InternalChatLayout.vue`:
  - **Scroll robusto:** `lastSentAt` — `sendMsg` rola imediatamente + "re-pin" após 120ms; `loadMsgs` rola pro fundo se `stickToBottom` **ou** se foi logo após enviar (`< 5s`).
  - **Merge safeguard:** `pendingLocal` ref — a mensagem recém-enviada fica na lista até o servidor confirmar; nunca some mesmo se um poll voltar sem ela.
- 💬 **Caixa de texto nova** igual ao ReplyBox do chat com cliente: `border border-n-weak rounded-xl bg-n-solid-1`, textarea `autoGrow`, botão anexar (clip) + botão **`Enviar (↵)`** (desabilitado sem conteúdo).
- **Arquivos:** `chatwoot-fix/InternalChatLayout.vue`

### v4.14.6 – Correção da ordem das mensagens (2026-08-02)

**Base:** `josuemadureira/chatwoot-custom:v4.14.5`. Backend + frontend (`internal_chat_controller.rb` + `InternalChatLayout.vue`).

- 🐛 **Ordem INVERTIDA** — após a v4.14.5, as mensagens novas apareciam em cima e as antigas embaixo.
- **Causa:** o `.order(created_at: :desc).limit(100).reverse` do controller **não invertia** — `.reverse` num `ActiveRecord::Relation` é **no-op** (a ordem vem do SQL; `reverse` em array é que inverte).
- **Correção:**
  - **Controller** (`def messages`): subquery `latest_ids` (100 mais recentes, desc) + `.where(id: latest_ids).order(created_at: :asc)` → devolve as 100 mais recentes **antiga → nova**. Testado via rails runner: `123808,...,142613` ✅.
  - **Frontend**: helper `sortMsgs` (ordena por `created_at` asc) aplicado no `loadMsgs` e `sendMsg` — defesa caso o servidor venha em outra ordem.
- **Arquivos:** `chatwoot-fix/internal_chat_controller.rb`, `chatwoot-fix/InternalChatLayout.vue`

> ⚠️ **LIÇÃO (importante):** em query de controller, **NUNCA** usar `.reverse` num `ActiveRecord::Relation` (é no-op). Para pegar os N mais recentes em ordem de exibição, usar subquery `latest_ids` (a ordem `desc` é feita no SQL; depois re-ordena `asc`).

### v4.14.7 – Menu de contexto (botão direito) Editar/Excluir (2026-08-03)

**Base:** `josuemadureira/chatwoot-custom:v4.14.6`. Só o frontend mudou (`InternalChatLayout.vue` + assets Vite recompilados).

- 🖱️ **Editar/Excluir via menu de contexto** — ao clicar com o **botão direito** em uma mensagem sua, abre um menu no mesmo estilo do chat com cliente (componentes `ContextMenu` + `MenuItem` reutilizados: fundo `bg-n-background shadow-xl rounded-md`, item com hover `bg-n-brand text-white`, ícones `edit`/`delete`).
- O menu aparece **só nas mensagens do próprio agente** dentro da janela de edição (15 min). Em mensagens de outros (ou antigas), o menu nativo do navegador continua funcionando.
- Removidos os antigos links "editar/excluir" que apareciam no hover.
- ⚠️ **Por que o chat do cliente não tem Editar/Excluir:** a API do Meta/WhatsApp **não permite** editar/excluir mensagens de WhatsApp — por isso o menu do cliente só tem copiar/responder/etc. O Chat Interno (mensagens `message_type: :internal`, banco próprio) **pode**, então usa a mesma identidade visual com as opções de edição.
- **Arquivo:** `chatwoot-fix/InternalChatLayout.vue`

### v4.14.8 – Root cause do "msg some em conversa de 2 pessoas" (2026-08-03)

**Base:** `josuemadureira/chatwoot-custom:v4.14.7`. Só o backend mudou (`internal_chat_controller.rb`).

- 🐛 **Sintoma:** as mensagens sumiam ~3s após enviar **apenas na conversa de 2 pessoas** (Vanessa↔Iara, conversation id 4480, com **132 msgs internas**) — a única conversa com **>100 msgs**. As demais (com menos de 100) funcionavam.
- **Causa raiz:** o model `Message` tem `default_scope { order(created_at: :asc) }`. O `latest_ids` do controller usava `.order(created_at: :desc).limit(100)`, mas em Rails **`.order` não sobrescreve o default_scope — ele acrescenta** → o SQL virava `ORDER BY created_at ASC, created_at DESC` (efetivamente ASC) → `limit(100)` retornava as **100 MAIS ANTIGAS**, cortando as novas. Assim, numa conversa com >100 msgs, a mensagem enviada aparecia (push local) e **sumia no próximo polling (3s)** porque o servidor não a devolvia.
- **Correção:** trocar `.order(created_at: :desc)` por **`.reorder(created_at: :desc)`** no `latest_ids` (e `.reorder(created_at: :asc)` na query final, defensivo). `.reorder` **substitui** o default_scope. Validado via rails runner na 4480: `latest_ids` passa a incluir `142683` (a mais nova) e a lista final termina nela.
- **Arquivo:** `chatwoot-fix/internal_chat_controller.rb`

> ⚠️ **LIÇÃO (importante):** quando o model tiver `default_scope` de ordenação, **NUNCA** usar `.order` em query de controller — usar **`.reorder`** (`order()` acrescenta, `reorder()` substitui). É o mesmo tipo de pegadinha do `.reverse` (que era no-op).

### v4.14.9 – Feature "Responder" no Chat Interno (2026-08-03)

**Base:** `josuemadureira/chatwoot-custom:v4.14.8`. Backend + frontend (`internal_chat_controller.rb` + `InternalChatLayout.vue`).

- 💬 **Responder qualquer mensagem** do Chat Interno (suas ou da colega), de 2 formas:
  - **Botão direito** → menu com **Responder** (primeiro item, ícone `arrow-reply`) — abre para qualquer mensagem;
  - **Duplo clique** na mensagem → inicia o reply direto.
- **Barra "Respondendo a \<nome\>: \<texto\>"** no composer (igual ao `ReplyToMessage.vue` do cliente), com X para cancelar.
- **Citação dentro da bolha** da mensagem enviada (`bg-n-alpha-black1`), clicável → **rola até a mensagem original**.
- **Backend:** `create_message` grava `content_attributes.in_reply_to` (helper `parse_content_attributes`, aceita JSON string do FormData); `serialize_message` inclui `replied_to` (helper `serialize_replied_to` — `{id, content, deleted, created_at, sender}`).
- 🐛 **Bug de deploy:** a 1ª build do v4.14.9 zerou a lista do Chat Interno ("Nenhuma conversa ainda") — `serialize_replied_to` usava `@conversation.messages` e o `@conversation` é `nil` na action `index` (que itera conversas locais, sem instanciar). **Fix:** `msg.conversation.messages` — funciona em qualquer contexto. ⚠️ **LIÇÃO: helpers de serialização não podem depender de `@conversation` quando chamados por actions que não o setam.**
- **Arquivos:** `chatwoot-fix/internal_chat_controller.rb`, `chatwoot-fix/InternalChatLayout.vue`

### v4.15.0 – Melhoria da edição + duplo clique no chat do cliente (2026-08-03)

**Base:** `josuemadureira/chatwoot-custom:v4.14.9`. Só o frontend mudou (`InternalChatLayout.vue` + `Message.vue` + assets Vite recompilados).

- 🖱️ **Edição sem conflito:** durante a edição de uma mensagem, o **duplo clique** agora seleciona texto (não ativa reply) e o **botão direito** abre o **corretor ortográfico** do SO (o menu Editar/Excluir/Responder fica desabilitado). Handlers `onBubbleContextMenu`/`onBubbleDblClick` ignoram a mensagem em edição.
- ✏️ **Edição caprichada:** barra **"Editando mensagem"** com ícone, foco automático com cursor no fim, textarea com auto-grow, **Enter salva / Esc cancela**, botões `NextButton` (Salvar azul com loading + Cancelar ghost). Ao editar, limpa reply pendente (edição tem prioridade).
- 📱 **Duplo clique responde no chat do cliente:** `Message.vue` (components-next) ganhou `@dblclick` na bolha → `handleReplyTo()` — mesma regra do menu "Responder" (`replyTo`), ignorando links/imagens/`.skip-context-menu`. O Chat Interno já tinha; agora o cliente também.
- **Arquivos:** `chatwoot-fix/InternalChatLayout.vue`, `chatwoot-fix/message/Message.vue`

### v1.2 – Notificações Inteligentes (Recomendada)
- **Título da notificação**: Nome do contato (ex: "João Silva")
- **Corpo da notificação**: Prévia real da última mensagem recebida
- Se for apenas anexo → mostra "Enviou um anexo"
- Comportamento igual ao **WhatsApp** e **Telegram**
- Funciona perfeitamente no navegador (Service Worker) e no app mobile
- Removeu completamente o antigo texto "A new message is created in conversation (#ID)"

### v1 – Bloqueio de Atendimentos Duplicados
- Impede que dois agentes atendam o mesmo cliente ao mesmo tempo
- Evita conflitos e bagunça nos atendimentos

---

## 🛠️ Build da imagem

A pasta [`chatwoot-fix/`](./chatwoot-fix) contém os arquivos corrigidos e o Dockerfile do overlay.

### Como funciona
A imagem é construída **em cima da base v4.14.2**, apenas copiando os arquivos corrigidos por cima (não recompila o Chatwoot inteiro).

```dockerfile
# chatwoot-fix/Dockerfile
FROM josuemadureira/chatwoot-custom:v4.14.2
# Correções dos bugs 1 e 2 (backend)
COPY internal_chat_controller.rb /app/app/controllers/api/v1/accounts/internal_chat_controller.rb
# Correção do bug 3 (frontend) — assets Vite recompilados
COPY public/vite/ /app/public/vite/
```

### Passo a passo

```bash
# 1. Arquivos necessários (já estão na pasta chatwoot-fix/)
#    - internal_chat_controller.rb  (backend corrigido)
#    - InternalChatLayout.vue       (fonte do componente corrigido — referência)
#    - public/vite/                 (frontend recompilado — assets do build Vite)
#
# 2. Build da imagem
cd chatwoot-fix
docker build -t josuemadureira/chatwoot-custom:v4.15.0 .

# 3. Push para o Docker Hub
docker login -u josuemadureira
docker push josuemadureira/chatwoot-custom:v4.15.0
```

---

## 🔧 Como recompilar o frontend (Bug 3)

A correção do Bug 3 é no Vue (`InternalChatLayout.vue`) e exige recompilar os assets. O Chatwoot v4.14 usa **Vite** + **pnpm 10** (Node 24):

```bash
# No repositório do Chatwoot (fonte completa)
cd <repo-chatwoot>
pnpm install --frozen-lockfile                # instala dependências
pnpm rebuild esbuild core-js vue-demi         # garante binários nativos (pnpm 10 bloqueia postinstall)

# Build de produção do frontend
NODE_ENV=production pnpm exec vite build

# O resultado fica em public/vite/
# (o chunk InternalChatLayout-*.js é o componente corrigido)
```

> ⚠️ No Windows, o `package.json` precisa da config `pnpm.onlyBuiltDependencies` com `esbuild`, `core-js` e `vue-demi` para o pnpm 10 rodar os scripts de build (necessário para o Vite funcionar).

---

## 🚀 Deploy

O Chatwoot roda em Docker (gerenciado pelo Portainer). O compose usa as imagens `josuemadureira/chatwoot-custom:v4.14.x`.

1. Faça **backup do compose** antes de editar.
2. No compose, troque a versão (`v4.14.9` → `v4.15.0`) em `chatwoot_app` e `chatwoot_sidekiq`.
3. Suba apenas os serviços alterados (Postgres/Redis ficam intocados):

```bash
docker compose -f <caminho-compose> -p chatwoot up -d chatwoot_app chatwoot_sidekiq
```

4. Verifique: `curl localhost:3000` (esperado `301`) + `docker ps`.

---

## 📁 Estrutura deste repositório

| Pasta/Arquivo | Conteúdo |
|---|---|
| `chatwoot-fix/Dockerfile` | Overlay da imagem v4.15.0 |
| `chatwoot-fix/internal_chat_controller.rb` | Controller corrigido (bugs 1 e 2 + `latest_ids` com `.reorder` + reply `in_reply_to`/`replied_to`) |
| `chatwoot-fix/InternalChatLayout.vue` | Componente corrigido (scroll + merge + caixa nova + menu de contexto + **Responder** + edição melhorada) — referência |
| `chatwoot-fix/message/Message.vue` | Componente do chat do cliente com **duplo clique para responder** — referência |
| `README.md` | Este documento |

---

## 🧠 Contexto do Chat Interno (referência)

O "Chat Interno" é uma customização do Chatwoot onde agentes conversam entre si (mensagens `message_type: :internal`, marcadas com `conversations.internal = true` e `participant_ids` em `additional_attributes`). O controller principal é `app/controllers/api/v1/accounts/internal_chat_controller.rb`.
