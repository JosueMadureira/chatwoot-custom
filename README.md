# Chatwoot Custom

**Versão customizada do Chatwoot com melhorias focadas na experiência do agente.**

[![Docker Pulls](https://img.shields.io/docker/pulls/josemadureira/chatwoot-custom)](https://hub.docker.com/r/josemadureira/chatwoot-custom)

---

## 📌 Imagens Docker disponíveis

| Imagem | Descrição |
|---|---|
| `josuemadureira/chatwoot-custom:1.17.0` | **Atual + EM PRODUÇÃO** (deploy 2026-08-20) — 1.16.0 + **nova permissão de Função Personalizada "Gerenciar conversas do time atribuído"** (para contas onde os Times são os departamentos reais, com Caixa de Entrada única) + **fix crítico: permissões de conversa eram hierarquia exclusiva, agora somam** (marcar duas permissões juntas escondia conversas que uma delas deveria liberar) |
| `josuemadureira/chatwoot-custom:1.16.0` | 1.15.2 + **aba "Participando" na tela principal de conversas** (entre Minhas e Não atribuídas), aparece só quando há conversas de participação |
| `josuemadureira/chatwoot-custom:1.15.2` | 1.15.1 + **fix real (backend) das conversas de participante que somiam** — o `assigneeType: 'me'` continuava sendo enviado ao servidor e cortava de novo por atribuição |
| `josuemadureira/chatwoot-custom:1.15.1` | 1.15.0 + **fix (frontend) das conversas de participante que somiam na tela "Participando"** (filtro duplicado por atribuição removido) |
| `josuemadureira/chatwoot-custom:1.15.0` | 1.14.2 + **badge do Chat Interno no menu** (carrega ao abrir o Chatwoot, não só ao entrar na tela) + **número no ícone do app** (barra de tarefas do Windows, via Badging API) + fix custom_role em conversas de participante |
| `josuemadureira/chatwoot-custom:1.14.2` | 1.14.1 + **fix: Chat Interno desaparecia para agentes com função customizada (Custom Role)** (a rota exigia `agent`/`administrator`; quem tinha role customizada como "Atendente" não tinha nenhuma das duas → menu some. Agora libera também para `custom_role`, igual outras telas do Chatwoot) |
| `josuemadureira/chatwoot-custom:1.14.1` | 1.14.0 + **fix crítico do envio falsamente marcado como "não enviado"** (o handler do flash do quote desestruturava payload `undefined` do `SCROLL_TO_MESSAGE` → `TypeError` → mensagem ficava vermelha mesmo sendo entregue; agora o handler tem default `= {}` + guarda — flash do quote mantido e envio normalizado) |
| `josuemadureira/chatwoot-custom:1.14.0` | 1.13.2 + **mensagem marcada/citada "pisca em amarelo" ao clicar na prévia do quote** (estilo WhatsApp, rola até a mensagem exata e destaca) — no chat com cliente e no Chat Interno |
| `josuemadureira/chatwoot-custom:1.13.2` | 1.13.1 + **fix definitivo do check azul ao responder** (`create_message` agora marca a leitura — se um colega responde sua mensagem mesmo com a conversa já aberta, o check ✓✓ azul acende na hora; antes ficava cinza para sempre nesse cenário) |
| `josuemadureira/chatwoot-custom:1.13.1` | 1.13.0 + **fix da confirmação de leitura (check ✓✓ azul) e do contador de não lidas** (mensagens que chegam com a conversa aberta agora são marcadas como lidas no polling — antes só ao abrir) + **botão "+" no fim dos emojis rápidos de reação** (abre o picker completo de emojis) + **arquivos enviados maiores** (imagens 200×150 → 280×210, documento com chip maior) |
| `josuemadureira/chatwoot-custom:1.13.0` | 1.12.0 + **reações de mensagens com emoji** no Chat Interno (hover → picker rápido, chips com contagem, toggle estilo WhatsApp) + **anexar agora fica no composer** (igual Ctrl+V: preview, escreve texto e Envia) + **duplo clique para responder removido** (só botão direito) |
| `josuemadureira/chatwoot-custom:1.12.0` | 1.11.0 + **emojis maiores nas mensagens** (35% maiores que o texto, via MessageFormatter + `emoji-regex`) e **no picker de emoji** (itens 24px, botões 36px, diálogo maior) no Chat Interno, no dashboard e no widget |
| `josuemadureira/chatwoot-custom:1.11.0` | 1.10.1 + **painel de detalhes de grupo** no Chat Interno (ⓘ: ver participantes, admin renomeia/adiciona/remove, não-admin sai do grupo) + **contador de não lidas por conversa** (pill azul estilo WhatsApp) + botões maiores + grupo exige mínimo 2 pessoas |
| `josuemadureira/chatwoot-custom:1.10.1` | 1.10.0 + **fix do botão 👥 invisível** no Chat Interno (o ícone `people-outline` era buscado como `people-outline-outline`, que não existe → crash no render; agora é `people`) |
| `josuemadureira/chatwoot-custom:1.10.0` | 1.9.1 + **fix nome de arquivos recebidos** (remove o sufixo `;filename*=`), **reply/quote resolve mensagens de conversas antigas** (prévia + navegação) e **grupos no Chat Interno** (`+` = conversa direta, botão 👥 cria grupo com nome, membros de grupo podem receber conversa direta) |
| `josuemadureira/chatwoot-custom:1.9.1` | 1.9.0 + **fix**: a pill de data de um dia anterior não fica mais presa no topo junto com a do dia atual (cada pill agora fica dentro do bloco do seu dia — o próximo dia "empurra" a anterior) |
| `josuemadureira/chatwoot-custom:1.9.0` | 1.8.0 + **pill de data gruda no topo** (sticky) ao rolar as mensagens do dia, igual WhatsApp |
| `josuemadureira/chatwoot-custom:1.8.0` | 1.7.2 + **separador de data** nas mensagens do Chat Interno (pill **"Hoje" / "Ontem" / dd/mm/aaaa**, igual WhatsApp do celular) |
| `josuemadureira/chatwoot-custom:1.7.2` | 1.7.1 + **launcher do Copiloto sobe no Chat Interno** para não tampar o botão "Enviar (↵)" |
| `josuemadureira/chatwoot-custom:1.7.1` | 1.7.0 + **"Selecionar" no menu de botão direito** (junto de Responder/Encaminhar) + **fix do picker de emoji** (abre junto ao botão, acima e à esquerda — não corta mais) |
| `josuemadureira/chatwoot-custom:1.7.0` | 1.6.0 + **Encaminhar mensagens** (única ou várias, texto+imagem juntos, tag "↪ Encaminhada de X") + **botão de emoji** no composer |
| `josuemadureira/chatwoot-custom:1.6.0` | 1.5.0 + **links clicáveis no Chat Interno** (markdown-it + linkify igual ao chat do cliente, `target=_blank`) |
| `josuemadureira/chatwoot-custom:1.5.0` | 1.4.0 + melhoria da edição (foco/Enter/Esc/botões, sem conflito com duplo clique e corretor) + **duplo clique responde no chat do cliente** |
| `josuemadureira/chatwoot-custom:1.4.0` | 1.3.1 + feature **Responder** no Chat Interno (botão direito + duplo clique, citação na bolha) + fix do bug que zerava a lista (serialize usava `@conversation` nil no `index`) |
| `josuemadureira/chatwoot-custom:1.3.1` | 1.3.0 + ROOT CAUSE do "msg some em conversa de 2 pessoas" (default_scope do Message anulava o `.order` → fix `.reorder`) |
| `josuemadureira/chatwoot-custom:1.3.0` | 1.2.1 + menu de contexto (botão direito) Editar/Excluir igual ao chat com cliente |
| `josuemadureira/chatwoot-custom:1.2.1` | v4.14.5 (tag antiga, sem release própria) + correção da ORDEM das mensagens (antiga→nova) |
| `josuemadureira/chatwoot-custom:v4.14.5` ⚠️ *sem tag SemVer — nunca teve release no GitHub, superada no dia seguinte pela 1.2.1* | 1.2.0 + fix do bug da mensagem que sumia (scroll robusto + merge safeguard) + caixa de texto nova (igual ao ReplyBox do cliente) |
| `josuemadureira/chatwoot-custom:1.2.0` | 1.1.1 + melhorias visuais do Chat Interno (balões/avatares iguais ao cliente, checks ✓✓ entregue/lido, colar imagem com Ctrl+V) |
| `josuemadureira/chatwoot-custom:1.1.1` | v4.14.2 (imagem base) + correção dos 3 bugs do Chat Interno |
| `josuemadureira/chatwoot-custom:v4.14.2` ⚠️ *imagem base oficial do Chatwoot (não customizada por nós) — não recebe tag SemVer própria, é o `FROM` do Dockerfile* | Produção em uso até 2026-08-02 (sem as correções) — base dos overlays |
| `josuemadureira/chatwoot-custom:1.1.0` | Versão antiga (Notificações Inteligentes) |

```bash
# Baixar a imagem atual
docker pull josuemadureira/chatwoot-custom:1.17.0
```

---

## 🏷️ Releases no GitHub

Cada versão publicada no Docker Hub tem uma **Release** correspondente no GitHub, com o histórico completo das mudanças:

| Release | Destaque |
|---|---|
| [1.17.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.17.0) — **Latest** | Permissão "Gerenciar conversas do time atribuído" + fix crítico: permissões de conversa somam (não são mais hierarquia exclusiva) |
| [1.16.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.16.0) | Aba "Participando" na tela principal de conversas (entre Minhas e Não atribuídas) |
| [1.15.2](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.15.2) | Fix real (backend) das conversas de participante que somiam |
| [1.15.1](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.15.1) | Fix (frontend) das conversas de participante que somiam na tela "Participando" |
| [1.15.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.15.0) | Badge do Chat Interno no menu + número no ícone do app (Badging API) |
| [1.14.2](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.14.2) | Fix: Chat Interno desaparecia para agentes com função customizada (Custom Role) — rota agora libera `custom_role` além de `agent`/`administrator` |
| [1.14.1](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.14.1) | Fix crítico do envio falsamente marcado como "não enviado" (handler do flash do quote com default `={}` + guarda; envio normalizado, flash do quote mantido) |
| [1.14.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.14.0) | Mensagem marcada/citada "pisca em amarelo" ao clicar na prévia do quote (estilo WhatsApp) — chat com cliente e Chat Interno |
| [1.13.2](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.13.2) | Fix definitivo do check azul ao responder: `create_message` agora marca a leitura — respondendo a conversa (mesmo sem reabrir) o check ✓✓ do remetente acende na hora |
| [1.13.1](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.13.1) | Fix da confirmação de leitura (✓✓ azul) e do contador de não lidas (leitura agora marca no polling, sem reabrir) + botão "+" nos emojis de reação (picker completo) + arquivos enviados maiores |
| [1.13.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.13.0) | Reações com emoji no Chat Interno (estilo WhatsApp) + anexar fica no composer (igual Ctrl+V) + remoção do duplo clique para responder |
| [1.12.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.12.0) | Emojis maiores nas mensagens (35%) + picker de emoji maior (itens 24px, botões 36px) em todo o Chatwoot |
| [1.11.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.11.0) | Painel de detalhes de grupo (admin renomeia/adiciona/remove; não-admin sai) + contador de não lidas por conversa |
| [1.10.1](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.10.1) | Fix do botão 👥 invisível no Chat Interno (ícone `people-outline` → `people`) |
| [1.10.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.10.0) | Fix do `;filename*=` nos nomes de arquivos recebidos + reply/quote de conversas antigas (prévia + navegação) + grupos no Chat Interno |
| [1.9.1](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.9.1) | Fix da pill de data presa (03/08 junto com Hoje) — pill agora fica no bloco do seu dia |
| [1.9.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.9.0) | Pill de data **sticky** (gruda no topo ao rolar o dia, igual WhatsApp) |
| [1.8.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.8.0) | Separador de data no Chat Interno ("Hoje" / "Ontem" / dd/mm/aaaa) |
| [1.7.2](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.7.2) | Copiloto não tampa mais o botão de enviar no Chat Interno |
| [1.7.1](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.7.1) | "Selecionar" no botão direito + fix do picker de emoji |
| [1.7.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.7.0) | Encaminhar mensagens (estilo WhatsApp) + emoji no composer |
| [1.6.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.6.0) | Links clicáveis no Chat Interno (markdown-it + linkify) |
| [1.5.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.5.0) | Edição de mensagens melhorada + duplo clique responde no chat do cliente |
| [1.4.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.4.0) | Feature **Responder** no Chat Interno (botão direito + duplo clique) |
| [1.3.1](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.3.1) | ROOT CAUSE do bug "msg some" (default_scope do Message) |
| [1.3.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.3.0) | Menu de contexto Editar/Excluir no Chat Interno |
| [1.2.1](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.2.1) | Fix ordem invertida das mensagens |
| [1.2.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.2.0) | Melhorias visuais do Chat Interno |
| [1.1.1](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/1.1.1) | Correção dos 3 bugs do Chat Interno |

---

## ✨ Funcionalidades Implementadas
### 1.17.0 – Permissão de time + fix permissões que não somavam (2026-08-20)

**Base:** `josuemadureira/chatwoot-custom:1.16.0`. Backend + frontend. **EM PRODUÇÃO** (deploy autorizado, 2026-08-20). **ESTE É O ÚLTIMO.**

#### ✨ Nova permissão: "Gerenciar conversas do time atribuído"
- Contexto do cliente: o Chatwoot foi desenhado para departamentos = Caixas de Entrada, mas nesta conta todos os departamentos (Times) atendem o **mesmo número/inbox** — a permissão certa precisava ser por **Time**, não por Inbox.
- Nova permissão de Função Personalizada `conversation_team_manage` ("Gerenciar conversas do time atribuído e aquelas atribuídas a elas") — libera acesso a qualquer conversa atribuída a um Time do qual o agente faça parte, além das atribuídas a ele individualmente.
- **Backend:** `CustomRole::PERMISSIONS` (nova entrada), `Enterprise::Conversations::PermissionFilterService` (filtro de listagem por `team_id: user.teams`), `Enterprise::ConversationPolicy` (`permits_team_manage?` reaproveitando `team_access?` já existente na policy base).
- **Frontend:** `constants/permissions.js` (`CONVERSATION_TEAM_PERMISSIONS`), `conversation.routes.js` (rota aceita a nova permissão), `CustomRoleModal.vue` (checkbox aparece automaticamente via `AVAILABLE_CUSTOM_ROLE_PERMISSIONS`), i18n.

#### 🐛 Fix crítico: permissões de conversa eram hierarquia exclusiva, não soma
- **Sintoma:** ao marcar **duas ou mais** permissões de conversa juntas numa Função Personalizada (ex: "Não atribuídas" + "Participando"), o sistema aplicava **só a primeira** que desse match num `if/elsif` — escondendo conversas que a outra permissão deveria liberar. Provável causa de reclamações de agentes não vendo conversas esperadas.
- **Fix:** as permissões agora **somam** (União de conjuntos) tanto no backend (`PermissionFilterService#filter_by_permissions` monta uma lista de scopes e faz `UNION`) quanto no frontend (`applyRoleFilter` em `helpers.js`, usado nas contagens/filtros em tempo real da aba "Todos").
- **Arquivos:** `enterprise/app/models/custom_role.rb`, `enterprise/app/services/enterprise/conversations/permission_filter_service.rb`, `enterprise/app/policies/enterprise/conversation_policy.rb`, `app/javascript/dashboard/constants/permissions.js`, `app/javascript/dashboard/store/modules/conversations/helpers.js`, `app/javascript/dashboard/store/modules/conversations/getters.js`, `app/javascript/dashboard/routes/dashboard/conversation/conversation.routes.js`, `app/javascript/dashboard/routes/dashboard/settings/customRoles/component/CustomRoleModal.vue`

### 1.16.0 – Aba "Participando" na tela principal de conversas (2026-08-20)

**Base:** `josuemadureira/chatwoot-custom:1.15.2`. Backend + frontend.

- ➕ **Nova aba "Participando"** entre **Minhas** e **Não atribuídas**, na tela principal de conversas — mostra as conversas onde o usuário participa (mesmo sem ser assignee).
- A aba só aparece quando há **ao menos 1** conversa de participação; some quando não há nenhuma (e volta automaticamente para "Minhas" se o usuário estiver nela quando isso acontecer).
- **Backend:** `ConversationFinder#set_count_for_all_conversations` agora retorna `participating_count`.
- **Arquivos:** `app/finders/conversation_finder.rb`, `app/javascript/dashboard/components/ChatList.vue`, `app/javascript/dashboard/store/modules/conversationStats.js`, `app/javascript/dashboard/constants/globals.js`, `app/javascript/dashboard/constants/permissions.js`, i18n `chatlist.json`

### 1.15.2 – Fix real (backend) das conversas de participante que somiam (2026-08-20)

**Base:** `josuemadureira/chatwoot-custom:1.15.1`. Só o backend mudou (`conversation_finder.rb`).

- 🐛 **A 1.15.1 não resolveu de vez:** mesmo escondendo as abas visualmente, o parâmetro `assigneeType: 'me'` continuava sendo enviado ao servidor por baixo dos panos. O `ConversationFinder` aplicava esse filtro **por cima** do filtro de participação já correto, cortando de novo por `assignee_id`.
- 🔧 **Fix:** quando a tela é "Participando" (`conversation_type == 'participating'`), o backend não aplica mais o filtro extra de atribuição.
- **Arquivo:** `app/finders/conversation_finder.rb`

### 1.15.1 – Fix (frontend) das conversas de participante que somiam (2026-08-20)

**Base:** `josuemadureira/chatwoot-custom:1.15.0`. Só o frontend mudou (`ChatList.vue`).

- 🐛 **Sintoma:** a tela "Participando" tinha um filtro extra por atribuição (aba Minhas/Não atribuídas/Todas) rodando por cima da lista já filtrada por participação — escondendo justamente as conversas onde o usuário é só participante.
- 🔧 **Fix:** removido o filtro duplicado; a aba de filtro também foi ocultada nessa tela.
- **Arquivo:** `app/javascript/dashboard/components/ChatList.vue`

### 1.15.0 – Badge do Chat Interno + número no ícone do app (2026-08-20)

**Base:** `josuemadureira/chatwoot-custom:1.14.2`. Frontend + backend.

- 🔔 **Contador do Chat Interno no menu** agora é buscado assim que o Chatwoot abre (não só ao entrar na tela do Chat Interno) e atualizado a cada 15s.
- 🔢 **Número no ícone do app** (barra de tarefas do Windows) via Badging API (`navigator.setAppBadge`), somando Caixa de Entrada + Chat Interno — igual WhatsApp Desktop/Outlook (requer o Chatwoot instalado como PWA).
- 🐛 **Fix:** custom role com permissão "participando" não via conversas onde o usuário era apenas participante.
- **Arquivos:** `app/javascript/dashboard/components-next/sidebar/Sidebar.vue`, `enterprise/app/services/enterprise/conversations/permission_filter_service.rb`

### 1.14.2 – Fix: Chat Interno some para agentes com função customizada (2026-08-20)

**Base:** `josuemadureira/chatwoot-custom:1.14.1`. Só o frontend mudou (rota + assets Vite recompilados).

- 🟥 **Sintoma:** ao criar uma função customizada (ex: "Atendente") na tela de Custom Roles e atribuí-la a agentes, o item **"Chat Interno" desaparecia do menu lateral** para esses agentes — e a rota ficava inacessível (redirecionava para o dashboard).
- **Root cause:** a rota do Chat Interno (`internal_chat/routes.js`) define `meta.permissions: ['administrator', 'agent']`. Quando um usuário tem uma `custom_role` atribuída, o backend (`Enterprise::AccountUser#permissions`) retorna `custom_role.permissions + ['custom_role']` **em vez de** `['agent']`/`['administrator']` — mesmo que o usuário continue sendo um agente comum. Como a rota não aceitava `'custom_role'`, `hasPermissions` retornava `false` e o item do menu (`SidebarGroup.vue`, via `<Policy>`/`usePolicy`) e a própria rota ficavam bloqueados para qualquer agente com função customizada.
- 🔧 **Fix:** `meta.permissions: ['administrator', 'agent', 'custom_role']` — mesmo padrão já usado em outras telas do Chatwoot (ex: `notifications/routes.js`).
- ✅ **Resultado:** o Chat Interno agora aparece e funciona **independente da função** (padrão ou customizada) atribuída ao agente.
- **Arquivo:** `app/javascript/dashboard/routes/dashboard/internal_chat/routes.js`

### 1.14.1 – Fix crítico: envio falsamente marcado como "não enviado" (2026-08-12)

**Base:** `josuemadureira/chatwoot-custom:1.14.0`. Frontend do chat com cliente (`Message.vue`). **EM PRODUÇÃO** (deploy autorizado, 2026-08-12).

- 🟥 **Sintoma (introduzido na 1.14.0):** ao enviar qualquer mensagem ao cliente, a bolha ficava **vermelha** com o aviso **"Não foi possível enviar esta mensagem, por favor, tente novamente mais tarde"** — e o erro **sumia ao reiniciar** (Ctrl+Shift+R). O usuário reenviou várias vezes achando que não tinha ido.
- **A verdade:** as mensagens **ESTAVAM sendo entregues** no servidor (banco mostrava `delivered`/`read`) — era **alarme falso** no frontend. Mas, como parecia falha, o usuário reenviou → **duplicatas** chegaram aos clientes entre ~18:26–18:42.
- **Root cause:** o handler do destaque de mensagem citada (1.14.0) fazia `const handleScrollToMessage = ({ messageId }) => {...}` — mas o evento `SCROLL_TO_MESSAGE` é emitido **sem payload** em vários lugares logo após o envio (só para rolar até o fim): `ReplyBox.vue`, `store/modules/conversations`, `InboxView.vue`. Desestruturar payload `undefined` lançava **`TypeError`**, que caía no `catch` do fluxo de envio → mensagem marcada como falha.
- 🔧 **Fix:** default no argumento + guarda:
  ```js
  const handleScrollToMessage = ({ messageId } = {}) => {
    // payload undefined = scroll-to-bottom pós-envio (não é um quote) — ignora
    if (!messageId || Number(messageId) !== Number(props.id)) return;
    flashHighlight();
    document.getElementById(`message${props.id}`)?.scrollIntoView({ behavior: 'smooth', block: 'center' });
  };
  ```
- ✅ **Resultado:** flash do quote **continua** (com `messageId`), scroll pós-envio é **ignorado** (sem `messageId`) e o envio **não é mais marcado como falha** — confirmado pelo usuário ("Normalizou, graças a Deus").
- ⚠️ **LIÇÃO:** ao registrar `emitter.on(SCROLL_TO_MESSAGE, handler)`, o handler **DEVE** tratar payload `undefined` (default `= {}` + guarda), pois o evento é disparado **com e sem** payload.
- **Arquivo:** `app/javascript/dashboard/components-next/message/Message.vue`

### 1.14.0 – Mensagem marcada "pisca" ao clicar na prévia do quote (2026-08-12)

**Base:** `josuemadureira/chatwoot-custom:1.13.2`. Frontend do Chat Interno + chat do cliente. **EM PRODUÇÃO** (deploy autorizado, 2026-08-12).

- 🟡 **Sintoma:** ao clicar na prévia do quote (mensagem citada/marcada), a conversa rolava mas **não destacava qual mensagem é** — o agente ficava sem saber a qual mensagem o cliente se referia.
- **Causa:** no chat com cliente, o evento `SCROLL_TO_MESSAGE` (emitido ao clicar na prévia) **não tinha ouvinte** no components-next (só no `MessagesView.vue` antigo, não usado) → o clique não fazia nada; e o destaque por `?messageId` usava `bg-n-alpha-1` por 1s — quase invisível.
- **Fix:**
  - **Chat com cliente (`Message.vue`):** cada mensagem agora **ouve** `SCROLL_TO_MESSAGE` — ao clicar na prévia, a mensagem alvo **rola para o centro e pisca em amarelo** por 2s (`message-flash-highlight`, animação CSS). O mesmo flash mais visível vale para o `?messageId` (quote de outra conversa).
  - **Chat Interno (`InternalChatLayout.vue`):** `scrollToMessage` agora também **destaca** a mensagem citada (`internal-msg-highlight`), mesma animação.
- **Resultado:** clicar na prévia do quote **mostra exatamente** a mensagem citada — igual ao WhatsApp, no chat com cliente e no Chat Interno.
- **Arquivos:** `Message.vue` (ouvinte `SCROLL_TO_MESSAGE` + flash + animação CSS), `InternalChatLayout.vue` (`scrollToMessage` destaca + animação CSS)

### 1.13.2 – Fix definitivo do check azul ao responder (2026-08-12)

**Base:** `josuemadureira/chatwoot-custom:1.13.1`. Backend-only (sem mudança de frontend). **EM PRODUÇÃO** (deploy autorizado, 2026-08-12).

- 🟦 **Sintoma:** os checks azuis tinham voltado a funcionar na 1.13.1, mas pararam de novo — havia conversas **já respondidas** com o check ainda cinza.
- **Root cause:** o `read_conversation` (que preenche `read_by` e acende o check) só rodava ao **abrir** a conversa ou no polling quando ela estava fechada. Se a conversa **já estava aberta** e o colega respondia sem reabrir, a resposta era criada via `create_message` — que **não marcava leitura** — então o check do remetente ficava cinza para sempre, mesmo com a conversa respondida.
- 🔧 **Fix:** `create_message` agora chama o helper `mark_internal_conversation_read` **depois** de criar a mensagem — quem respondeu, leu (semântica WhatsApp: responder = ler). O `read_conversation` foi refatorado para usar o **mesmo helper** (fonte única de verdade).
- ✅ **Resultado:** quando um colega responde sua mensagem, o check azul acende **na hora** — independente de reabrir ou não a conversa, em qualquer versão de cliente/tab.
- **Arquivo:** `chatwoot-fix/internal_chat_controller.rb` (`create_message` + `read_conversation` → helper `mark_internal_conversation_read`)

### 1.13.1 – Fix leitura (check azul) + contador + "+" na reação + arquivos maiores (2026-08-12)

**Base:** `josuemadureira/chatwoot-custom:1.13.0`. Frontend do Chat Interno. **EM PRODUÇÃO** (deploy autorizado, 2026-08-12).

- 🟦 **Confirmação de leitura (check ✓✓ azul) voltou + contador de não lidas correto:** root cause único — o `read_conversation` (que preenche `read_by` e zera o contador) só rodava ao **abrir** a conversa, nunca no polling de 3s. Mensagens que chegavam com a conversa aberta ficavam "não lidas" até sair/entrar → check do colega ficava cinza e o contador parecia "contar as minhas mensagens". **Fix:** `loadMsgs` chama `read_conversation` no polling se houver mensagens de outros não lidas por mim (com guarda — não posta à toa). Check azul agora aparece assim que o colega lê, e o contador some sem reabrir.
- ➕ **Botão "+" no fim dos emojis rápidos de reação:** abre o **picker completo de emojis** (busca + categorias — o mesmo `EmojiInput` do composer); emoji clicado reage normalmente (toggle estilo WhatsApp).
- 📎 **Arquivos enviados maiores:** imagens `200×150px` → `280×210px`; documento com chip maior (padding/ícone/texto) e nome truncado.
- **Arquivo:** `app/javascript/dashboard/components-next/InternalChat/InternalChatLayout.vue` (read-on-poll + "+" + picker completo + tamanho dos anexos).

### 1.13.0 – Reações + anexo no composer + remover duplo clique (2026-08-12)

**Base:** `josuemadureira/chatwoot-custom:1.12.0`. Frontend + backend do Chat Interno. **EM PRODUÇÃO** (deploy autorizado, 2026-08-12).

- 😍 **Reações de mensagens com emoji (Chat Interno, estilo WhatsApp):** hover na mensagem → botão de reação no canto inferior da bolha → picker rápido (👍 ❤️ 😂 😮 😢 🙏 🔥 🎉). **Chips com contagem** abaixo da bolha (`👍 2`, highlight azul se você já reagiu); clicar no mesmo emoji **remove**, reagir com outro **troca**. Backend próprio (não depende da Meta): reações em `content_attributes['reactions']` + nova action `POST /internal_chat/:id/react_message` (só participantes da conversa).
- 📎 **Anexar arquivo agora fica no composer (não envia direto):** antes o clipe mandava o documento na hora; agora fica como preview no composer (imagem = thumbnail, documento = chip com nome) e só envia quando você digita e aperta **Enviar (↵)** — igual ao Ctrl+V. Dá para remover o anexo pendente (×) e escolher o mesmo arquivo de novo.
- 🖱️ **Duplo clique para responder REMOVIDO:** duplo clique não abre mais o reply (atrapalhava copiar texto); **Responder só pelo botão direito** (menu → "Responder").
- **Arquivos:** `internal_chat_controller.rb` (action `react_message` + `reactions` no `serialize_message`), `config/routes.rb` (rota member), `InternalChatLayout.vue` (reações + staging de anexos + remoção do duplo clique).

### 1.12.0 – Emojis maiores nas mensagens + picker (2026-08-11)

**Base:** `josuemadureira/chatwoot-custom:1.11.0`. Só o frontend mudou (assets Vite recompilados). **EM PRODUÇÃO** (deploy autorizado, 2026-08-11).

- 😀 **Emojis maiores nas mensagens (padrão WhatsApp):** cada emoji agora é renderizado **35% maior** que o texto nas mensagens do **Chat Interno**, das **conversas do dashboard** e do **widget do cliente** (enviadas e recebidas).
  - O `MessageFormatter` (markdown-it) embrulha cada emoji num `<span class="emoji">` (via `emoji-regex` — sequências ZWJ, tom de pele e bandeiras ficam num span único, sem quebrar).
  - Code blocks, links e imagens não são afetados; o texto puro é preservado.
- 🎯 **Picker de emoji maior:** itens da grade 18px → **24px** com botões de 36px (antes 26px), diálogo maior (`w-96` + altura), ícones de categoria no rodapé 14px → **20px**. Vale para widget, ReplyBox e Chat Interno (compartilham o `EmojiInput.vue`).
- ⌨️ **Sugestões do `:` no editor:** emoji subiu de `text-sm` → `text-lg`.
- **Arquivos:** `shared/helpers/MessageFormatter.js` (+ `emoji-regex` como dependência), `shared/components/emoji/EmojiInput.vue`, `keyboardEmojiSelector.vue`, `tailwind.config.js` (`.emoji` no `typography.bubble`) e `widget/assets/scss/woot.scss` (`.emoji` no widget).

### 1.11.0 – Painel de Detalhes de Grupo + Contador de não lidas (2026-08-11)

**Base:** `josuemadureira/chatwoot-custom:1.10.1`. Backend + frontend. **EM PRODUÇÃO** (deploy autorizado, 2026-08-11).

- 👥 **Painel de Detalhes de Grupo:** botão **ⓘ** no header do Chat Interno (só em grupos) abre uma coluna à direita (estilo painel do cliente) com avatares, nome, nº de participantes, **Admin** (criador) e data de criação.
  - **Criador (admin):** pode **renomear** (input inline), **adicionar** membros (modal com checkboxes) e **remover** membros (confirmação inline "Sim?"). Não pode remover a si mesmo.
  - **Não-criadores:** veem a lista sem botões de gestão e têm **"Sair do grupo"** no rodapé (confirmação inline "Sair mesmo?").
  - **Backend:** `update_group` (só o criador; valida add/remove/rename, bloqueia remover o criador), `leave_group` (só não-criador), `creator_id` gravado na criação e exposto na serialização (`creator`). Data-fix: "Clube das Winx" (conv 4722) → `creator_id = 9` (Brenno).
- 🔔 **Contador de não lidas por conversa (estilo WhatsApp):** pill azul com o nº de mensagens internas não lidas na lista, zerado ao abrir a conversa (mecanismo `read_by` por mensagem); mostra "99+" acima de 99.
- 🎛 **Botões maiores e mais usáveis:** ⓘ Detalhes, 👥 Criar grupo, ➕ Nova conversa, ➕ Adicionar membro e 🗑 Remover do grupo agora são botões `size-9` com ícone 20 — clicáveis de verdade, sem "sujeirinhas".
- 🔒 **Trava de grupo:** o botão **"Criar grupo"** fica **desabilitado** (esmaecido) até selecionar **mínimo 2 pessoas**; a validação também exige ≥2.
- **Arquivos:** `internal_chat_controller.rb` + `config/routes.rb` + `InternalChatLayout.vue` (+ assets Vite recompilados).

### 1.10.1 – Fix do botão 👥 invisível (2026-08-11)

**Base:** `josuemadureira/chatwoot-custom:1.10.0`. Só o frontend mudou (`InternalChatLayout.vue` + assets Vite recompilados).

- 👥 **Fix:** o botão **Criar grupo** (`people-outline`) ficava **invisível** no Chat Interno — a equipe não via o botão para criar grupo.
  - **Causa raiz:** o componente de ícone global busca no `dashboard-icons.json` a chave **`{nome}-{tipo}`** (tipo default = `outline`). O botão usava `icon="people-outline"` → a busca virava `people-outline-outline`, que **não existe** no JSON → `path` fica `undefined` → `path.constructor` lança erro de render → o ícone não desenhava nada (botão vazio/invisível). O `+` funcionava porque `icon="add"` → `add-outline` existe.
  - **Correção:** `icon="people"` (o sufixo `-outline` é acrescentado automaticamente → `people-outline`, que existe).
  - ⚠️ **LIÇÃO:** as chaves do `dashboard-icons.json` **já incluem o sufixo** (`people-outline`, `add-outline`, ...). Ao usar `<fluent-icon>`, passe o nome **sem** o sufixo (`icon="people"`), nunca `icon="people-outline"`.
- **Arquivo:** `chatwoot-fix/InternalChatLayout.vue`

### 1.10.0 – Nomes de arquivos limpos + reply de conversas antigas + grupos (2026-08-11)

**Base:** `josuemadureira/chatwoot-custom:1.9.1`. Backend + frontend. **EM PRODUÇÃO** (deploy autorizado, 2026-08-11).

#### 📎 1. Fix: arquivos recebidos com `;filename*=` no nome
- 🐛 **Sintoma:** quase todos os anexos recebidos (WhatsApp/360dialog) salvavam com o sufixo literal **`;filename*=`** no fim do nome (ex: `CCT_2026_-_CAPITAL_COMPLETA.pdf;filename*=`), obrigando a equipe a renomear o arquivo a cada download.
- **Causa raiz:** a 360dialog responde a mídia com `Content-Disposition` tipo `...pdf; filename*=UTF-8''...`. O `Down.download` grava **tudo isso** no `original_filename`, que vira o nome do blob (`active_storage_blobs.filename`). O download usa esse nome.
- 🔧 **Correção (novos arquivos):** `attach_files` agora passa o nome por `sanitize_filename` (corta no `;filename*=` e limpa) antes de salvar no blob. Aplica-se a 360dialog e Cloud (compartilham o método).
- 🗄️ **Correção (arquivos já recebidos):** data-fix no banco — `UPDATE active_storage_blobs SET filename = split_part(filename, ';filename*=', 1)` (renomear a coluna é seguro; o arquivo físico usa a storage key, separada). **2300 blobs corrigidos** em produção.
- **Arquivo:** `chatwoot-fix/app/services/whatsapp/incoming_message_base_service.rb`

#### 💬 2. Fix: mensagens respondidas (quote) de conversas antigas
- 🐛 **Sintoma:** quando o cliente cita uma mensagem de uma **conversa antiga** (resolvida), a prévia não aparecia e clicar não abria o histórico.
- **Causa:** o backend (`InReplyToMessageBuilder`) só procurava a mensagem citada na **conversa atual** (`conversation.messages.find_by(source_id:)`); o frontend (`MessageList.vue`) só buscava da conversa atual.
- 🔧 **Backend:** o builder agora procura o `source_id` também em **todas as conversas do contato** (`contact_inbox.conversations`) e grava `content_attributes.in_reply_to_conversation_id` com a conversa da mensagem citada.
- 🔧 **Frontend:** `MessageList.vue` usa `in_reply_to_conversation_id` para buscar a prévia da conversa certa; `bubbles/Base.vue` — ao **clicar** na citação de outra conversa, navega até ela com `?messageId=` (o `ConversationView` já rola até a mensagem via `setActiveChat`).
- **Arquivos:** `chatwoot-fix/app/services/messages/in_reply_to_message_builder.rb`, `chatwoot-fix/message/MessageList.vue`, `chatwoot-fix/message/bubbles/Base.vue`

#### 👥 3. Grupos no Chat Interno (pedido da equipe)
- 🐛 **Antes:** no botão **`+`** dava para selecionar **vários** contatos e "grupos" eram criados por engano. Depois, os membros do grupo **sumiam** do picker de conversa (tratados como "já têm conversa aberta") → impossível abrir conversa direta com eles.
- ✅ **Agora:**
  - O **`+`** cria **conversa direta** (seleção de **1** pessoa, radio).
  - Novo botão **👥** (ícone `people-outline`) ao lado do `+` → modal **"Novo Grupo"** com **nome do grupo** + seleção múltipla → `create_group` (backend: `additional_attributes.type = internal_group` + `group_name`).
  - **Participantes de grupo voltam a aparecer** no picker de conversa direta: o filtro `has_open_chat` agora considera **apenas conversas diretas (2 participantes)**.
  - Grupos exibem o **nome próprio** na lista e no header.
  - O grupo criado pela equipe foi renomeado para **"Clube das Winx"** (data-fix no banco).
- **Arquivos:** `chatwoot-fix/internal_chat_controller.rb`, `chatwoot-fix/config/routes.rb`, `chatwoot-fix/InternalChatLayout.vue`

### 1.9.1 – Fix da pill de data presa no topo (2026-08-07)

**Base:** `josuemadureira/chatwoot-custom:1.9.0`. Só o frontend mudou (`InternalChatLayout.vue` + assets Vite recompilados).

- 🐛 **Fix:** na 1.9.0, a pill de um dia anterior (ex: "03/08/2026") **ficava presa no topo junto com a pill do dia atual** ("Hoje") ao rolar a conversa. **Causa:** o `position: sticky` da pill tinha como "containing block" o container inteiro da lista → uma vez presa, não soltava mais, e a pill do próximo dia chegava e **sobrepunha** a anterior.
- 🔧 **Correção:** as mensagens agora são agrupadas por dia (`dayGroups` — chave + label + itens) e cada dia vira um **bloco** (`position: relative`). A pill `sticky` fica **presa só dentro do bloco do seu dia** — quando o próximo dia entra, a pill anterior é **empurrada para fora**, sem sobrepor (igual WhatsApp).
- **Arquivo:** `chatwoot-fix/InternalChatLayout.vue`

### 1.9.0 – Pill de data fixa no topo (sticky) (2026-08-07)

**Base:** `josuemadureira/chatwoot-custom:1.8.0`. Só o frontend mudou (`InternalChatLayout.vue` + assets Vite recompilados).

- 📌 **A pill de data gruda no topo da tela** enquanto você rola as mensagens do dia (igual WhatsApp) — quando as mensagens do dia **ultrapassam a altura da tela**, o separador fica fixo no topo até o próximo dia empurrar a anterior. Implementado com `position: sticky` (CSS puro, sem JS de scroll).
- **Arquivo:** `chatwoot-fix/InternalChatLayout.vue`

### 1.8.0 – Separador de data no Chat Interno (2026-08-07)

**Base:** `josuemadureira/chatwoot-custom:1.7.2`. Só o frontend mudou (`InternalChatLayout.vue` + assets Vite recompilados).

- 📅 **Separador de data** nas mensagens do Chat Interno, **igual ao WhatsApp do celular**: uma pill centralizada mostra **"Hoje"**, **"Ontem"** ou a data **dd/mm/aaaa**, exibida quando muda o dia entre mensagens e também no topo da conversa.
- **Arquivo:** `chatwoot-fix/InternalChatLayout.vue`

### 1.7.2 – Copiloto não tampa o botão de enviar (2026-08-07)

**Base:** `josuemadureira/chatwoot-custom:1.7.1`. Só o frontend mudou (`CopilotLauncher.vue` + assets Vite recompilados).

- 🤖 **Launcher do Copiloto sobe no Chat Interno** (`bottom-24`) para **não tampar o botão "Enviar (↵)"** do composer no rodapé. Nas outras telas continua `bottom-4`.
- **Arquivo:** `chatwoot-fix/copilot/CopilotLauncher.vue`

### 1.7.1 – Ajustes: Selecionar no botão direito + fix do emoji (2026-08-07)

**Base:** `josuemadureira/chatwoot-custom:1.7.0`. Só o frontend mudou (`InternalChatLayout.vue`).

- 🎯 **"Selecionar" saiu do header e foi para o menu de botão direito**, junto de Responder/Encaminhar (ícone `checkmark`) — igual as outras opções. Ao clicar, ativa o modo de seleção já marcando a mensagem.
- 🔧 **Fix do picker de emoji:** abria longe do botão e cortado no canto da tela. Agora ancorado ao botão (wrapper `relative` + CSS scoped `.internal-chat-emoji`) e abre **acima e à esquerda**, sem cortar — igual ao ReplyBox do cliente.
- **Arquivo:** `chatwoot-fix/InternalChatLayout.vue`

### 1.7.0 – Encaminhar mensagens + Emoji no Chat Interno (2026-08-07)

**Base:** `josuemadureira/chatwoot-custom:1.6.0`. Backend + frontend (`internal_chat_controller.rb` + `config/routes.rb` + `InternalChatLayout.vue`).

- 📤 **Encaminhar mensagens** (estilo WhatsApp):
  - **Botão direito** → menu com **Encaminhar** (única mensagem), ou **modo de seleção** para encaminhar várias de uma vez para outra conversa interna.
  - **Texto + imagem vão juntos** na mesma bolha, igual na fonte (cada mensagem vira UMA nova no destino).
  - Tag **"↪ Encaminhada de \<nome\>"** na bolha encaminhada.
  - **Backend:** nova action `forward` (rota `post :forward`, adicionada em `config/routes.rb` — a base v4.14.2 não tem essa rota); valida participante no destino; copia `content` + attachments **reusando o blob do ActiveStorage** (sem re-upload); `broadcast_message` refatorado para aceitar a conversa destino (notificação no destino); `serialize_message` expõe `forwarded`/`forwarded_from`.
- 😊 **Botão de emoji** no composer do Chat Interno (componente `EmojiInput` compartilhado, picker em popover).
- **Arquivos:** `chatwoot-fix/internal_chat_controller.rb`, `chatwoot-fix/config/routes.rb`, `chatwoot-fix/InternalChatLayout.vue`

### 1.6.0 – Links clicáveis no Chat Interno (2026-08-05)

**Base:** `josuemadureira/chatwoot-custom:1.5.0`. Só o frontend mudou (`InternalChatLayout.vue` + assets Vite recompilados).

- 🔗 **Links clicáveis nas mensagens do Chat Interno** — antes, URLs eram texto puro (sem link). Agora o conteúdo passa pelo `MessageFormatter` (markdown-it + linkify) — **o mesmo mecanismo do chat com cliente** — e os links viram âncoras clicáveis com `target="_blank"`, `rel="noreferrer noopener nofollow"` e classe `.link`.
- **Renderização:** `<div class="prose prose-bubble break-words" v-dompurify-html="formatMessage(msg.content)" />` (mesmas classes e sanitização do `FormattedContent.vue` do cliente — `v-dompurify-html` é diretiva global registrada no Chatwoot).
- **Helper:** `formatMessage(content)` → `new MessageFormatter(content).formattedMessage` (vazio-safe).
- **Arquivo:** `chatwoot-fix/InternalChatLayout.vue`

### 1.5.0 – Melhoria da edição + duplo clique no chat do cliente (2026-08-03)

**Base:** `josuemadureira/chatwoot-custom:1.4.0`. Só o frontend mudou (`InternalChatLayout.vue` + `Message.vue` + assets Vite recompilados).

- 🖱️ **Edição sem conflito:** durante a edição de uma mensagem, o **duplo clique** agora seleciona texto (não ativa reply) e o **botão direito** abre o **corretor ortográfico** do SO (o menu Editar/Excluir/Responder fica desabilitado). Handlers `onBubbleContextMenu`/`onBubbleDblClick` ignoram a mensagem em edição.
- ✏️ **Edição caprichada:** barra **"Editando mensagem"** com ícone, foco automático com cursor no fim, textarea com auto-grow, **Enter salva / Esc cancela**, botões `NextButton` (Salvar azul com loading + Cancelar ghost). Ao editar, limpa reply pendente (edição tem prioridade).
- 📱 **Duplo clique responde no chat do cliente:** `Message.vue` (components-next) ganhou `@dblclick` na bolha → `handleReplyTo()` — mesma regra do menu "Responder" (`replyTo`), ignorando links/imagens/`.skip-context-menu`. O Chat Interno já tinha; agora o cliente também.
- **Arquivos:** `chatwoot-fix/InternalChatLayout.vue`, `chatwoot-fix/message/Message.vue`

### 1.4.0 – Feature "Responder" no Chat Interno (2026-08-03)

**Base:** `josuemadureira/chatwoot-custom:1.3.1`. Backend + frontend (`internal_chat_controller.rb` + `InternalChatLayout.vue`).

- 💬 **Responder qualquer mensagem** do Chat Interno (suas ou da colega), de 2 formas:
  - **Botão direito** → menu com **Responder** (primeiro item, ícone `arrow-reply`) — abre para qualquer mensagem;
  - **Duplo clique** na mensagem → inicia o reply direto.
- **Barra "Respondendo a \<nome\>: \<texto\>"** no composer (igual ao `ReplyToMessage.vue` do cliente), com X para cancelar.
- **Citação dentro da bolha** da mensagem enviada (`bg-n-alpha-black1`), clicável → **rola até a mensagem original**.
- **Backend:** `create_message` grava `content_attributes.in_reply_to` (helper `parse_content_attributes`, aceita JSON string do FormData); `serialize_message` inclui `replied_to` (helper `serialize_replied_to` — `{id, content, deleted, created_at, sender}`).
- 🐛 **Bug de deploy:** a 1ª build do 1.4.0 zerou a lista do Chat Interno ("Nenhuma conversa ainda") — `serialize_replied_to` usava `@conversation.messages` e o `@conversation` é `nil` na action `index` (que itera conversas locais, sem instanciar). **Fix:** `msg.conversation.messages` — funciona em qualquer contexto. ⚠️ **LIÇÃO: helpers de serialização não podem depender de `@conversation` quando chamados por actions que não o setam.**
- **Arquivos:** `chatwoot-fix/internal_chat_controller.rb`, `chatwoot-fix/InternalChatLayout.vue`

### 1.3.1 – Root cause do "msg some em conversa de 2 pessoas" (2026-08-03)

**Base:** `josuemadureira/chatwoot-custom:1.3.0`. Só o backend mudou (`internal_chat_controller.rb`).

- 🐛 **Sintoma:** as mensagens sumiam ~3s após enviar **apenas na conversa de 2 pessoas** (Vanessa↔Iara, conversation id 4480, com **132 msgs internas**) — a única conversa com **>100 msgs**. As demais (com menos de 100) funcionavam.
- **Causa raiz:** o model `Message` tem `default_scope { order(created_at: :asc) }`. O `latest_ids` do controller usava `.order(created_at: :desc).limit(100)`, mas em Rails **`.order` não sobrescreve o default_scope — ele acrescenta** → o SQL virava `ORDER BY created_at ASC, created_at DESC` (efetivamente ASC) → `limit(100)` retornava as **100 MAIS ANTIGAS**, cortando as novas. Assim, numa conversa com >100 msgs, a mensagem enviada aparecia (push local) e **sumia no próximo polling (3s)** porque o servidor não a devolvia.
- **Correção:** trocar `.order(created_at: :desc)` por **`.reorder(created_at: :desc)`** no `latest_ids` (e `.reorder(created_at: :asc)` na query final, defensivo). `.reorder` **substitui** o default_scope. Validado via rails runner na 4480: `latest_ids` passa a incluir `142683` (a mais nova) e a lista final termina nela.
- **Arquivo:** `chatwoot-fix/internal_chat_controller.rb`

> ⚠️ **LIÇÃO (importante):** quando o model tiver `default_scope` de ordenação, **NUNCA** usar `.order` em query de controller — usar **`.reorder`** (`order()` acrescenta, `reorder()` substitui). É o mesmo tipo de pegadinha do `.reverse` (que era no-op).

### 1.3.0 – Menu de contexto (botão direito) Editar/Excluir (2026-08-03)

**Base:** `josuemadureira/chatwoot-custom:1.2.1`. Só o frontend mudou (`InternalChatLayout.vue` + assets Vite recompilados).

- 🖱️ **Editar/Excluir via menu de contexto** — ao clicar com o **botão direito** em uma mensagem sua, abre um menu no mesmo estilo do chat com cliente (componentes `ContextMenu` + `MenuItem` reutilizados: fundo `bg-n-background shadow-xl rounded-md`, item com hover `bg-n-brand text-white`, ícones `edit`/`delete`).
- O menu aparece **só nas mensagens do próprio agente** dentro da janela de edição (15 min). Em mensagens de outros (ou antigas), o menu nativo do navegador continua funcionando.
- Removidos os antigos links "editar/excluir" que apareciam no hover.
- ⚠️ **Por que o chat do cliente não tem Editar/Excluir:** a API do Meta/WhatsApp **não permite** editar/excluir mensagens de WhatsApp — por isso o menu do cliente só tem copiar/responder/etc. O Chat Interno (mensagens `message_type: :internal`, banco próprio) **pode**, então usa a mesma identidade visual com as opções de edição.
- **Arquivo:** `chatwoot-fix/InternalChatLayout.vue`

### 1.2.1 – Correção da ordem das mensagens (2026-08-02)

**Base:** `josuemadureira/chatwoot-custom:v4.14.5`. Backend + frontend (`internal_chat_controller.rb` + `InternalChatLayout.vue`).

- 🐛 **Ordem INVERTIDA** — após a v4.14.5, as mensagens novas apareciam em cima e as antigas embaixo.
- **Causa:** o `.order(created_at: :desc).limit(100).reverse` do controller **não invertia** — `.reverse` num `ActiveRecord::Relation` é **no-op** (a ordem vem do SQL; `reverse` em array é que inverte).
- **Correção:**
  - **Controller** (`def messages`): subquery `latest_ids` (100 mais recentes, desc) + `.where(id: latest_ids).order(created_at: :asc)` → devolve as 100 mais recentes **antiga → nova**. Testado via rails runner: `123808,...,142613` ✅.
  - **Frontend**: helper `sortMsgs` (ordena por `created_at` asc) aplicado no `loadMsgs` e `sendMsg` — defesa caso o servidor venha em outra ordem.
- **Arquivos:** `chatwoot-fix/internal_chat_controller.rb`, `chatwoot-fix/InternalChatLayout.vue`

> ⚠️ **LIÇÃO (importante):** em query de controller, **NUNCA** usar `.reverse` num `ActiveRecord::Relation` (é no-op). Para pegar os N mais recentes em ordem de exibição, usar subquery `latest_ids` (a ordem `desc` é feita no SQL; depois re-ordena `asc`).

### v4.14.5 ⚠️ *(sem tag SemVer própria — nunca teve release, superada no dia seguinte pela 1.2.1)* – Fix do bug "mensagem some" + caixa de texto nova (2026-08-02)

**Base:** `josuemadureira/chatwoot-custom:1.2.0`. Só o frontend mudou (`InternalChatLayout.vue` + assets Vite recompilados).

- 🐛 **Bug da mensagem que sumia ~3s** — o polling de 3s substituía a lista inteira e, se o `stickToBottom` estivesse `false` no meio, a mensagem nova (no fim da lista) saía da área visível → "sumia". Correção em 2 frentes no `InternalChatLayout.vue`:
  - **Scroll robusto:** `lastSentAt` — `sendMsg` rola imediatamente + "re-pin" após 120ms; `loadMsgs` rola pro fundo se `stickToBottom` **ou** se foi logo após enviar (`< 5s`).
  - **Merge safeguard:** `pendingLocal` ref — a mensagem recém-enviada fica na lista até o servidor confirmar; nunca some mesmo se um poll voltar sem ela.
- 💬 **Caixa de texto nova** igual ao ReplyBox do chat com cliente: `border border-n-weak rounded-xl bg-n-solid-1`, textarea `autoGrow`, botão anexar (clip) + botão **`Enviar (↵)`** (desabilitado sem conteúdo).
- **Arquivos:** `chatwoot-fix/InternalChatLayout.vue`

### 1.2.0 – Melhorias visuais do Chat Interno (2026-08-02)

**Base:** `josuemadureira/chatwoot-custom:1.1.1`. Apenas o frontend mudou (`InternalChatLayout.vue` + assets Vite recompilados).

- 🎨 **Balões iguais aos do chat com cliente** — mesmas cores (`bg-n-solid-blue` para o agente, `bg-n-slate-4` para os demais) e cantos arredondados `rounded-xl` com `rounded-br-sm`/`rounded-bl-sm`, replicando o `BaseBubble` da conversa normal.
- 👤 **Avatar lateral** em cada mensagem (de quem enviou à esquerda, do agente atual à direita), como na conversa com cliente.
- ✅ **Checks de entregue/lido iguais ao WhatsApp** — dois checks cinza (`i-lucide-check-check` + `text-n-slate-10`) = entregue; dois checks azuis (`text-[#7EB6FF]`) = lido (quando o destinatário abriu a conversa). Antes era `✓`/`✓✓` simples.
- 📋 **Colar imagem com Ctrl+V** — agora funciona como no chat do cliente: cole um print/arquivo de imagem direto no input, aparece o preview acima do campo, e envia junto com o texto (ou sozinho). Continua funcionando o botão de clip (upload de arquivo).
- **Arquivo:** `chatwoot-fix/InternalChatLayout.vue`

### 1.1.1 – Correção dos bugs do Chat Interno (2026-08-02)

**Base:** `josuemadureira/chatwoot-custom:v4.14.2` (NÃO é um build novo — é um overlay que só acrescenta os arquivos corrigidos por cima da base, sem tocar no banco).

Três bugs foram corrigidos:

#### 🐛 Bug 1 — Mensagem some no Chat Interno (só aparece na notificação)
- **Sintoma:** em conversas internas com mais de 100 mensagens, as novas mensagens não aparecem no chat — só chegam via notificação.
- **Causa:** a action `messages` usava `.order(created_at: :asc).limit(100)` → retornava as **100 mensagens mais antigas**, escondendo as novas.
- **Correção final (1.3.1):** subquery `latest_ids` busca os ids das **100 mais recentes** e devolve em ordem de exibição (antiga → nova). **Dois ajustes obrigatórios:**
  1. **1.2.1** — `.order(created_at: :desc).limit(100).pluck(:id)`: usar subquery `latest_ids` + re-ordenar `asc` (o `.reverse` num `ActiveRecord::Relation` é no-op).
  2. **1.3.1** — trocar `.order` por **`.reorder`** no `latest_ids`: o model `Message` tem `default_scope { order(created_at: :asc) }`, que **anulava** o `.order(created_at: :desc)` (em Rails, `order()` acrescenta, não substitui) e fazia o `limit(100)` voltar a retornar as 100 **mais antigas** — por isso o bug reaparecia em conversas >100 msgs (a de 2 pessoas).
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

### 1.1.0 – Notificações Inteligentes (Recomendada)
- **Título da notificação**: Nome do contato (ex: "João Silva")
- **Corpo da notificação**: Prévia real da última mensagem recebida
- Se for apenas anexo → mostra "Enviou um anexo"
- Comportamento igual ao **WhatsApp** e **Telegram**
- Funciona perfeitamente no navegador (Service Worker) e no app mobile
- Removeu completamente o antigo texto "A new message is created in conversation (#ID)"

### 1.0.0 – Bloqueio de Atendimentos Duplicados
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
# Backend (bugs 1 e 2 + forward + grupos)
COPY internal_chat_controller.rb /app/app/controllers/api/v1/accounts/internal_chat_controller.rb
# Rota do forward (Encaminhar) + create_group — a base v4.14.2 não tem essas rotas
COPY config/routes.rb /app/config/routes.rb
# 1.10.0: sanitização de filename de anexos recebidos (sufixo ";filename*=")
COPY app/services/whatsapp/incoming_message_base_service.rb /app/app/services/whatsapp/incoming_message_base_service.rb
# 1.10.0: reply/quote resolve mensagens citadas de conversas ANTIGAS do mesmo contato
COPY app/services/messages/in_reply_to_message_builder.rb /app/app/services/messages/in_reply_to_message_builder.rb
# Frontend — assets Vite recompilados
COPY public/vite/ /app/public/vite/
# Launcher do Copiloto (1.7.2) — sobe no Chat Interno
COPY copilot/CopilotLauncher.vue /app/app/javascript/dashboard/components-next/copilot/CopilotLauncher.vue
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
docker build -t josuemadureira/chatwoot-custom:1.17.0 .

# 3. Push para o Docker Hub
docker login -u josuemadureira
docker push josuemadureira/chatwoot-custom:1.17.0
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

O Chatwoot roda em Docker (gerenciado pelo Portainer). O compose usa as imagens `josuemadureira/chatwoot-custom:1.17.0`.

1. Faça **backup do compose** antes de editar.
2. No compose, troque a versão (`1.16.0` → `1.17.0`) em `chatwoot_app` e `chatwoot_sidekiq`.
3. Suba apenas os serviços alterados (Postgres/Redis ficam intocados):

```bash
docker compose -f <caminho-compose> -p chatwoot up -d chatwoot_app chatwoot_sidekiq
```

4. Verifique: `curl localhost:3000` (esperado `301`) + `docker ps`.

---

## 📁 Estrutura deste repositório

| Pasta/Arquivo | Conteúdo |
|---|---|
| `chatwoot-fix/Dockerfile` | Overlay da imagem 1.17.0 |
| `chatwoot-fix/internal_chat_controller.rb` | Controller corrigido (bugs 1 e 2 + `latest_ids` com `.reorder` + reply `in_reply_to`/`replied_to` + **forward** + **`create_group`** + `has_open_chat` só p/ conversas diretas) |
| `chatwoot-fix/config/routes.rb` | Rotas (inclui `post :forward` e `post :create_group` — a base v4.14.2 não tem) |
| `chatwoot-fix/app/services/whatsapp/incoming_message_base_service.rb` | Sanitização de filename de anexos recebidos (corta o sufixo `;filename*=`) — 1.10.0 |
| `chatwoot-fix/app/services/messages/in_reply_to_message_builder.rb` | Reply/quote resolve mensagens citadas de conversas ANTIGAS do contato + expõe `in_reply_to_conversation_id` — 1.10.0 |
| `chatwoot-fix/InternalChatLayout.vue` | Componente corrigido (scroll + merge + caixa nova + menu de contexto + **Responder** + edição melhorada + **links clicáveis** + **forward** + **emoji** + **Selecionar no menu** + **separador de data sticky por dia** + **`+` = conversa direta + botão 👥 Novo Grupo** + **fix ícone 👥** `icon="people"` + **flash da msg citada** `internal-msg-highlight`) — referência |
| `chatwoot-fix/message/Message.vue` | Componente do chat do cliente com **duplo clique para responder** + **flash da msg citada** `message-flash-highlight` (ouvinte `SCROLL_TO_MESSAGE` com default `={}` + guarda — fix 1.14.1) — referência |
| `chatwoot-fix/message/MessageList.vue` | Prévia de reply/quote busca da conversa certa (`in_reply_to_conversation_id`) — 1.10.0 |
| `chatwoot-fix/message/bubbles/Base.vue` | Clique na citação de outra conversa navega até ela (`?messageId=`) — 1.10.0 |
| `chatwoot-fix/copilot/CopilotLauncher.vue` | Launcher do Copiloto — **sobe no Chat Interno** para não tampar o botão de enviar (1.7.2) |
| `README.md` | Este documento |

---

## 🧠 Contexto do Chat Interno (referência)

O "Chat Interno" é uma customização do Chatwoot onde agentes conversam entre si (mensagens `message_type: :internal`, marcadas com `conversations.internal = true` e `participant_ids` em `additional_attributes`). O controller principal é `app/controllers/api/v1/accounts/internal_chat_controller.rb`.

