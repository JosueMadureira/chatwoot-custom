# Chatwoot Custom

**Versão customizada do Chatwoot com melhorias focadas na experiência do agente.**

[![Docker Pulls](https://img.shields.io/docker/pulls/josemadureira/chatwoot-custom)](https://hub.docker.com/r/josemadureira/chatwoot-custom)

---

## 📌 Imagens Docker disponíveis

| Imagem | Descrição |
|---|---|
| `josuemadureira/chatwoot-custom:v4.18.2` | **Atual + EM PRODUÇÃO** (deploy 2026-08-12) — v4.18.1 + **fix definitivo do check azul ao responder** (`create_message` agora marca a leitura — se um colega responde sua mensagem mesmo com a conversa já aberta, o check ✓✓ azul acende na hora; antes ficava cinza para sempre nesse cenário) |
| `josuemadureira/chatwoot-custom:v4.18.1` | v4.18.0 + **fix da confirmação de leitura (check ✓✓ azul) e do contador de não lidas** (mensagens que chegam com a conversa aberta agora são marcadas como lidas no polling — antes só ao abrir) + **botão "+" no fim dos emojis rápidos de reação** (abre o picker completo de emojis) + **arquivos enviados maiores** (imagens 200×150 → 280×210, documento com chip maior) |
| `josuemadureira/chatwoot-custom:v4.18.0` | v4.17.9 + **reações de mensagens com emoji** no Chat Interno (hover → picker rápido, chips com contagem, toggle estilo WhatsApp) + **anexar agora fica no composer** (igual Ctrl+V: preview, escreve texto e Envia) + **duplo clique para responder removido** (só botão direito) |
| `josuemadureira/chatwoot-custom:v4.17.9` | v4.17.8 + **emojis maiores nas mensagens** (35% maiores que o texto, via MessageFormatter + `emoji-regex`) e **no picker de emoji** (itens 24px, botões 36px, diálogo maior) no Chat Interno, no dashboard e no widget |
| `josuemadureira/chatwoot-custom:v4.17.8` | v4.17.7 + **painel de detalhes de grupo** no Chat Interno (ⓘ: ver participantes, admin renomeia/adiciona/remove, não-admin sai do grupo) + **contador de não lidas por conversa** (pill azul estilo WhatsApp) + botões maiores + grupo exige mínimo 2 pessoas |
| `josuemadureira/chatwoot-custom:v4.17.7` | v4.17.6 + **fix do botão 👥 invisível** no Chat Interno (o ícone `people-outline` era buscado como `people-outline-outline`, que não existe → crash no render; agora é `people`) |
| `josuemadureira/chatwoot-custom:v4.17.6` | v4.17.5 + **fix nome de arquivos recebidos** (remove o sufixo `;filename*=`), **reply/quote resolve mensagens de conversas antigas** (prévia + navegação) e **grupos no Chat Interno** (`+` = conversa direta, botão 👥 cria grupo com nome, membros de grupo podem receber conversa direta) |
| `josuemadureira/chatwoot-custom:v4.17.5` | v4.17.4 + **fix**: a pill de data de um dia anterior não fica mais presa no topo junto com a do dia atual (cada pill agora fica dentro do bloco do seu dia — o próximo dia "empurra" a anterior) |
| `josuemadureira/chatwoot-custom:v4.17.4` | v4.17.3 + **pill de data gruda no topo** (sticky) ao rolar as mensagens do dia, igual WhatsApp |
| `josuemadureira/chatwoot-custom:v4.17.3` | v4.17.2 + **separador de data** nas mensagens do Chat Interno (pill **"Hoje" / "Ontem" / dd/mm/aaaa**, igual WhatsApp do celular) |
| `josuemadureira/chatwoot-custom:v4.17.2` | v4.17.1 + **launcher do Copiloto sobe no Chat Interno** para não tampar o botão "Enviar (↵)" |
| `josuemadureira/chatwoot-custom:v4.17.1` | v4.17.0 + **"Selecionar" no menu de botão direito** (junto de Responder/Encaminhar) + **fix do picker de emoji** (abre junto ao botão, acima e à esquerda — não corta mais) |
| `josuemadureira/chatwoot-custom:v4.17.0` | v4.16.0 + **Encaminhar mensagens** (única ou várias, texto+imagem juntos, tag "↪ Encaminhada de X") + **botão de emoji** no composer |
| `josuemadureira/chatwoot-custom:v4.16.0` | v4.15.0 + **links clicáveis no Chat Interno** (markdown-it + linkify igual ao chat do cliente, `target=_blank`) |
| `josuemadureira/chatwoot-custom:v4.15.0` | v4.14.9 + melhoria da edição (foco/Enter/Esc/botões, sem conflito com duplo clique e corretor) + **duplo clique responde no chat do cliente** |
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
docker pull josuemadureira/chatwoot-custom:v4.18.2
```

---

## 🏷️ Releases no GitHub

Cada versão publicada no Docker Hub tem uma **Release** correspondente no GitHub, com o histórico completo das mudanças:

| Release | Destaque |
|---|---|
| [v4.18.2](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.18.2) — **Latest** | Fix definitivo do check azul ao responder: `create_message` agora marca a leitura — respondendo a conversa (mesmo sem reabrir) o check ✓✓ do remetente acende na hora |
| [v4.18.1](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.18.1) | Fix da confirmação de leitura (✓✓ azul) e do contador de não lidas (leitura agora marca no polling, sem reabrir) + botão "+" nos emojis de reação (picker completo) + arquivos enviados maiores |
| [v4.18.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.18.0) | Reações com emoji no Chat Interno (estilo WhatsApp) + anexar fica no composer (igual Ctrl+V) + remoção do duplo clique para responder |
| [v4.17.9](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.17.9) | Emojis maiores nas mensagens (35%) + picker de emoji maior (itens 24px, botões 36px) em todo o Chatwoot |
| [v4.17.8](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.17.8) | Painel de detalhes de grupo (admin renomeia/adiciona/remove; não-admin sai) + contador de não lidas por conversa |
| [v4.17.7](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.17.7) | Fix do botão 👥 invisível no Chat Interno (ícone `people-outline` → `people`) |
| [v4.17.6](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.17.6) | Fix do `;filename*=` nos nomes de arquivos recebidos + reply/quote de conversas antigas (prévia + navegação) + grupos no Chat Interno |
| [v4.17.5](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.17.5) | Fix da pill de data presa (03/08 junto com Hoje) — pill agora fica no bloco do seu dia |
| [v4.17.4](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.17.4) | Pill de data **sticky** (gruda no topo ao rolar o dia, igual WhatsApp) |
| [v4.17.3](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.17.3) | Separador de data no Chat Interno ("Hoje" / "Ontem" / dd/mm/aaaa) |
| [v4.17.2](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.17.2) | Copiloto não tampa mais o botão de enviar no Chat Interno |
| [v4.17.1](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.17.1) | "Selecionar" no botão direito + fix do picker de emoji |
| [v4.17.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.17.0) | Encaminhar mensagens (estilo WhatsApp) + emoji no composer |
| [v4.16.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.16.0) | Links clicáveis no Chat Interno (markdown-it + linkify) |
| [v4.15.0](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.15.0) | Edição de mensagens melhorada + duplo clique responde no chat do cliente |
| [v4.14.9](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.14.9) | Feature **Responder** no Chat Interno (botão direito + duplo clique) |
| [v4.14.8](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.14.8) | ROOT CAUSE do bug "msg some" (default_scope do Message) |
| [v4.14.7](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.14.7) | Menu de contexto Editar/Excluir no Chat Interno |
| [v4.14.6](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.14.6) | Fix ordem invertida das mensagens |
| [v4.14.4](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.14.4) | Melhorias visuais do Chat Interno |
| [v4.14.3](https://github.com/JosueMadureira/chatwoot-custom/releases/tag/v4.14.3) | Correção dos 3 bugs do Chat Interno |

---

## ✨ Funcionalidades Implementadas

### v4.18.2 – Fix definitivo do check azul ao responder (2026-08-12)

**Base:** `josuemadureira/chatwoot-custom:v4.18.1`. Backend-only (sem mudança de frontend). **EM PRODUÇÃO** (deploy autorizado, 2026-08-12).

- 🟦 **Sintoma:** os checks azuis tinham voltado a funcionar na v4.18.1, mas pararam de novo — havia conversas **já respondidas** com o check ainda cinza.
- **Root cause:** o `read_conversation` (que preenche `read_by` e acende o check) só rodava ao **abrir** a conversa ou no polling quando ela estava fechada. Se a conversa **já estava aberta** e o colega respondia sem reabrir, a resposta era criada via `create_message` — que **não marcava leitura** — então o check do remetente ficava cinza para sempre, mesmo com a conversa respondida.
- 🔧 **Fix:** `create_message` agora chama o helper `mark_internal_conversation_read` **depois** de criar a mensagem — quem respondeu, leu (semântica WhatsApp: responder = ler). O `read_conversation` foi refatorado para usar o **mesmo helper** (fonte única de verdade).
- ✅ **Resultado:** quando um colega responde sua mensagem, o check azul acende **na hora** — independente de reabrir ou não a conversa, em qualquer versão de cliente/tab.
- **Arquivo:** `chatwoot-fix/internal_chat_controller.rb` (`create_message` + `read_conversation` → helper `mark_internal_conversation_read`)

### v4.18.1 – Fix leitura (check azul) + contador + "+" na reação + arquivos maiores (2026-08-12)

**Base:** `josuemadureira/chatwoot-custom:v4.18.0`. Frontend do Chat Interno. **EM PRODUÇÃO** (deploy autorizado, 2026-08-12).

- 🟦 **Confirmação de leitura (check ✓✓ azul) voltou + contador de não lidas correto:** root cause único — o `read_conversation` (que preenche `read_by` e zera o contador) só rodava ao **abrir** a conversa, nunca no polling de 3s. Mensagens que chegavam com a conversa aberta ficavam "não lidas" até sair/entrar → check do colega ficava cinza e o contador parecia "contar as minhas mensagens". **Fix:** `loadMsgs` chama `read_conversation` no polling se houver mensagens de outros não lidas por mim (com guarda — não posta à toa). Check azul agora aparece assim que o colega lê, e o contador some sem reabrir.
- ➕ **Botão "+" no fim dos emojis rápidos de reação:** abre o **picker completo de emojis** (busca + categorias — o mesmo `EmojiInput` do composer); emoji clicado reage normalmente (toggle estilo WhatsApp).
- 📎 **Arquivos enviados maiores:** imagens `200×150px` → `280×210px`; documento com chip maior (padding/ícone/texto) e nome truncado.
- **Arquivo:** `app/javascript/dashboard/components-next/InternalChat/InternalChatLayout.vue` (read-on-poll + "+" + picker completo + tamanho dos anexos).

### v4.18.0 – Reações + anexo no composer + remover duplo clique (2026-08-12)

**Base:** `josuemadureira/chatwoot-custom:v4.17.9`. Frontend + backend do Chat Interno. **EM PRODUÇÃO** (deploy autorizado, 2026-08-12).

- 😍 **Reações de mensagens com emoji (Chat Interno, estilo WhatsApp):** hover na mensagem → botão de reação no canto inferior da bolha → picker rápido (👍 ❤️ 😂 😮 😢 🙏 🔥 🎉). **Chips com contagem** abaixo da bolha (`👍 2`, highlight azul se você já reagiu); clicar no mesmo emoji **remove**, reagir com outro **troca**. Backend próprio (não depende da Meta): reações em `content_attributes['reactions']` + nova action `POST /internal_chat/:id/react_message` (só participantes da conversa).
- 📎 **Anexar arquivo agora fica no composer (não envia direto):** antes o clipe mandava o documento na hora; agora fica como preview no composer (imagem = thumbnail, documento = chip com nome) e só envia quando você digita e aperta **Enviar (↵)** — igual ao Ctrl+V. Dá para remover o anexo pendente (×) e escolher o mesmo arquivo de novo.
- 🖱️ **Duplo clique para responder REMOVIDO:** duplo clique não abre mais o reply (atrapalhava copiar texto); **Responder só pelo botão direito** (menu → "Responder").
- **Arquivos:** `internal_chat_controller.rb` (action `react_message` + `reactions` no `serialize_message`), `config/routes.rb` (rota member), `InternalChatLayout.vue` (reações + staging de anexos + remoção do duplo clique).

### v4.17.9 – Emojis maiores nas mensagens + picker (2026-08-11)

**Base:** `josuemadureira/chatwoot-custom:v4.17.8`. Só o frontend mudou (assets Vite recompilados). **EM PRODUÇÃO** (deploy autorizado, 2026-08-11).

- 😀 **Emojis maiores nas mensagens (padrão WhatsApp):** cada emoji agora é renderizado **35% maior** que o texto nas mensagens do **Chat Interno**, das **conversas do dashboard** e do **widget do cliente** (enviadas e recebidas).
  - O `MessageFormatter` (markdown-it) embrulha cada emoji num `<span class="emoji">` (via `emoji-regex` — sequências ZWJ, tom de pele e bandeiras ficam num span único, sem quebrar).
  - Code blocks, links e imagens não são afetados; o texto puro é preservado.
- 🎯 **Picker de emoji maior:** itens da grade 18px → **24px** com botões de 36px (antes 26px), diálogo maior (`w-96` + altura), ícones de categoria no rodapé 14px → **20px**. Vale para widget, ReplyBox e Chat Interno (compartilham o `EmojiInput.vue`).
- ⌨️ **Sugestões do `:` no editor:** emoji subiu de `text-sm` → `text-lg`.
- **Arquivos:** `shared/helpers/MessageFormatter.js` (+ `emoji-regex` como dependência), `shared/components/emoji/EmojiInput.vue`, `keyboardEmojiSelector.vue`, `tailwind.config.js` (`.emoji` no `typography.bubble`) e `widget/assets/scss/woot.scss` (`.emoji` no widget).

### v4.17.8 – Painel de Detalhes de Grupo + Contador de não lidas (2026-08-11)

**Base:** `josuemadureira/chatwoot-custom:v4.17.7`. Backend + frontend. **EM PRODUÇÃO** (deploy autorizado, 2026-08-11).

- 👥 **Painel de Detalhes de Grupo:** botão **ⓘ** no header do Chat Interno (só em grupos) abre uma coluna à direita (estilo painel do cliente) com avatares, nome, nº de participantes, **Admin** (criador) e data de criação.
  - **Criador (admin):** pode **renomear** (input inline), **adicionar** membros (modal com checkboxes) e **remover** membros (confirmação inline "Sim?"). Não pode remover a si mesmo.
  - **Não-criadores:** veem a lista sem botões de gestão e têm **"Sair do grupo"** no rodapé (confirmação inline "Sair mesmo?").
  - **Backend:** `update_group` (só o criador; valida add/remove/rename, bloqueia remover o criador), `leave_group` (só não-criador), `creator_id` gravado na criação e exposto na serialização (`creator`). Data-fix: "Clube das Winx" (conv 4722) → `creator_id = 9` (Brenno).
- 🔔 **Contador de não lidas por conversa (estilo WhatsApp):** pill azul com o nº de mensagens internas não lidas na lista, zerado ao abrir a conversa (mecanismo `read_by` por mensagem); mostra "99+" acima de 99.
- 🎛 **Botões maiores e mais usáveis:** ⓘ Detalhes, 👥 Criar grupo, ➕ Nova conversa, ➕ Adicionar membro e 🗑 Remover do grupo agora são botões `size-9` com ícone 20 — clicáveis de verdade, sem "sujeirinhas".
- 🔒 **Trava de grupo:** o botão **"Criar grupo"** fica **desabilitado** (esmaecido) até selecionar **mínimo 2 pessoas**; a validação também exige ≥2.
- **Arquivos:** `internal_chat_controller.rb` + `config/routes.rb` + `InternalChatLayout.vue` (+ assets Vite recompilados).

### v4.17.7 – Fix do botão 👥 invisível (2026-08-11)

**Base:** `josuemadureira/chatwoot-custom:v4.17.6`. Só o frontend mudou (`InternalChatLayout.vue` + assets Vite recompilados).

- 👥 **Fix:** o botão **Criar grupo** (`people-outline`) ficava **invisível** no Chat Interno — a equipe não via o botão para criar grupo.
  - **Causa raiz:** o componente de ícone global busca no `dashboard-icons.json` a chave **`{nome}-{tipo}`** (tipo default = `outline`). O botão usava `icon="people-outline"` → a busca virava `people-outline-outline`, que **não existe** no JSON → `path` fica `undefined` → `path.constructor` lança erro de render → o ícone não desenhava nada (botão vazio/invisível). O `+` funcionava porque `icon="add"` → `add-outline` existe.
  - **Correção:** `icon="people"` (o sufixo `-outline` é acrescentado automaticamente → `people-outline`, que existe).
  - ⚠️ **LIÇÃO:** as chaves do `dashboard-icons.json` **já incluem o sufixo** (`people-outline`, `add-outline`, ...). Ao usar `<fluent-icon>`, passe o nome **sem** o sufixo (`icon="people"`), nunca `icon="people-outline"`.
- **Arquivo:** `chatwoot-fix/InternalChatLayout.vue`

### v4.17.6 – Nomes de arquivos limpos + reply de conversas antigas + grupos (2026-08-11)

**Base:** `josuemadureira/chatwoot-custom:v4.17.5`. Backend + frontend. **EM PRODUÇÃO** (deploy autorizado, 2026-08-11).

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

### v4.17.5 – Fix da pill de data presa no topo (2026-08-07)

**Base:** `josuemadureira/chatwoot-custom:v4.17.4`. Só o frontend mudou (`InternalChatLayout.vue` + assets Vite recompilados).

- 🐛 **Fix:** na v4.17.4, a pill de um dia anterior (ex: "03/08/2026") **ficava presa no topo junto com a pill do dia atual** ("Hoje") ao rolar a conversa. **Causa:** o `position: sticky` da pill tinha como "containing block" o container inteiro da lista → uma vez presa, não soltava mais, e a pill do próximo dia chegava e **sobrepunha** a anterior.
- 🔧 **Correção:** as mensagens agora são agrupadas por dia (`dayGroups` — chave + label + itens) e cada dia vira um **bloco** (`position: relative`). A pill `sticky` fica **presa só dentro do bloco do seu dia** — quando o próximo dia entra, a pill anterior é **empurrada para fora**, sem sobrepor (igual WhatsApp).
- **Arquivo:** `chatwoot-fix/InternalChatLayout.vue`

### v4.17.3 – Separador de data no Chat Interno (2026-08-07)

**Base:** `josuemadureira/chatwoot-custom:v4.17.2`. Só o frontend mudou (`InternalChatLayout.vue` + assets Vite recompilados).

- 📅 **Separador de data** nas mensagens do Chat Interno, **igual ao WhatsApp do celular**: uma pill centralizada mostra **"Hoje"**, **"Ontem"** ou a data **dd/mm/aaaa**, exibida quando muda o dia entre mensagens e também no topo da conversa.
- **Arquivo:** `chatwoot-fix/InternalChatLayout.vue`

### v4.17.4 – Pill de data fixa no topo (sticky) (2026-08-07)

**Base:** `josuemadureira/chatwoot-custom:v4.17.3`. Só o frontend mudou (`InternalChatLayout.vue` + assets Vite recompilados).

- 📌 **A pill de data gruda no topo da tela** enquanto você rola as mensagens do dia (igual WhatsApp) — quando as mensagens do dia **ultrapassam a altura da tela**, o separador fica fixo no topo até o próximo dia empurrar a anterior. Implementado com `position: sticky` (CSS puro, sem JS de scroll).
- **Arquivo:** `chatwoot-fix/InternalChatLayout.vue`

### v4.17.0 – Encaminhar mensagens + Emoji no Chat Interno (2026-08-07)

**Base:** `josuemadureira/chatwoot-custom:v4.16.0`. Backend + frontend (`internal_chat_controller.rb` + `config/routes.rb` + `InternalChatLayout.vue`).

- 📤 **Encaminhar mensagens** (estilo WhatsApp):
  - **Botão direito** → menu com **Encaminhar** (única mensagem), ou **modo de seleção** para encaminhar várias de uma vez para outra conversa interna.
  - **Texto + imagem vão juntos** na mesma bolha, igual na fonte (cada mensagem vira UMA nova no destino).
  - Tag **"↪ Encaminhada de \<nome\>"** na bolha encaminhada.
  - **Backend:** nova action `forward` (rota `post :forward`, adicionada em `config/routes.rb` — a base v4.14.2 não tem essa rota); valida participante no destino; copia `content` + attachments **reusando o blob do ActiveStorage** (sem re-upload); `broadcast_message` refatorado para aceitar a conversa destino (notificação no destino); `serialize_message` expõe `forwarded`/`forwarded_from`.
- 😊 **Botão de emoji** no composer do Chat Interno (componente `EmojiInput` compartilhado, picker em popover).
- **Arquivos:** `chatwoot-fix/internal_chat_controller.rb`, `chatwoot-fix/config/routes.rb`, `chatwoot-fix/InternalChatLayout.vue`

### v4.17.1 – Ajustes: Selecionar no botão direito + fix do emoji (2026-08-07)

**Base:** `josuemadureira/chatwoot-custom:v4.17.0`. Só o frontend mudou (`InternalChatLayout.vue`).

- 🎯 **"Selecionar" saiu do header e foi para o menu de botão direito**, junto de Responder/Encaminhar (ícone `checkmark`) — igual as outras opções. Ao clicar, ativa o modo de seleção já marcando a mensagem.
- 🔧 **Fix do picker de emoji:** abria longe do botão e cortado no canto da tela. Agora ancorado ao botão (wrapper `relative` + CSS scoped `.internal-chat-emoji`) e abre **acima e à esquerda**, sem cortar — igual ao ReplyBox do cliente.
- **Arquivo:** `chatwoot-fix/InternalChatLayout.vue`

### v4.17.2 – Copiloto não tampa o botão de enviar (2026-08-07)

**Base:** `josuemadureira/chatwoot-custom:v4.17.1`. Só o frontend mudou (`CopilotLauncher.vue` + assets Vite recompilados).

- 🤖 **Launcher do Copiloto sobe no Chat Interno** (`bottom-24`) para **não tampar o botão "Enviar (↵)"** do composer no rodapé. Nas outras telas continua `bottom-4`.
- **Arquivo:** `chatwoot-fix/copilot/CopilotLauncher.vue`

### v4.16.0 – Links clicáveis no Chat Interno (2026-08-05)

**Base:** `josuemadureira/chatwoot-custom:v4.15.0`. Só o frontend mudou (`InternalChatLayout.vue` + assets Vite recompilados).

- 🔗 **Links clicáveis nas mensagens do Chat Interno** — antes, URLs eram texto puro (sem link). Agora o conteúdo passa pelo `MessageFormatter` (markdown-it + linkify) — **o mesmo mecanismo do chat com cliente** — e os links viram âncoras clicáveis com `target="_blank"`, `rel="noreferrer noopener nofollow"` e classe `.link`.
- **Renderização:** `<div class="prose prose-bubble break-words" v-dompurify-html="formatMessage(msg.content)" />` (mesmas classes e sanitização do `FormattedContent.vue` do cliente — `v-dompurify-html` é diretiva global registrada no Chatwoot).
- **Helper:** `formatMessage(content)` → `new MessageFormatter(content).formattedMessage` (vazio-safe).
- **Arquivo:** `chatwoot-fix/InternalChatLayout.vue`

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
# Backend (bugs 1 e 2 + forward + grupos)
COPY internal_chat_controller.rb /app/app/controllers/api/v1/accounts/internal_chat_controller.rb
# Rota do forward (Encaminhar) + create_group — a base v4.14.2 não tem essas rotas
COPY config/routes.rb /app/config/routes.rb
# v4.17.6: sanitização de filename de anexos recebidos (sufixo ";filename*=")
COPY app/services/whatsapp/incoming_message_base_service.rb /app/app/services/whatsapp/incoming_message_base_service.rb
# v4.17.6: reply/quote resolve mensagens citadas de conversas ANTIGAS do mesmo contato
COPY app/services/messages/in_reply_to_message_builder.rb /app/app/services/messages/in_reply_to_message_builder.rb
# Frontend — assets Vite recompilados
COPY public/vite/ /app/public/vite/
# Launcher do Copiloto (v4.17.2) — sobe no Chat Interno
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
docker build -t josuemadureira/chatwoot-custom:v4.17.7 .

# 3. Push para o Docker Hub
docker login -u josuemadureira
docker push josuemadureira/chatwoot-custom:v4.17.7
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

O Chatwoot roda em Docker (gerenciado pelo Portainer). O compose usa as imagens `josuemadureira/chatwoot-custom:v4.17.7`.

1. Faça **backup do compose** antes de editar.
2. No compose, troque a versão (`v4.17.6` → `v4.17.7`) em `chatwoot_app` e `chatwoot_sidekiq`.
3. Suba apenas os serviços alterados (Postgres/Redis ficam intocados):

```bash
docker compose -f <caminho-compose> -p chatwoot up -d chatwoot_app chatwoot_sidekiq
```

4. Verifique: `curl localhost:3000` (esperado `301`) + `docker ps`.

---

## 📁 Estrutura deste repositório

| Pasta/Arquivo | Conteúdo |
|---|---|
| `chatwoot-fix/Dockerfile` | Overlay da imagem v4.17.7 |
| `chatwoot-fix/internal_chat_controller.rb` | Controller corrigido (bugs 1 e 2 + `latest_ids` com `.reorder` + reply `in_reply_to`/`replied_to` + **forward** + **`create_group`** + `has_open_chat` só p/ conversas diretas) |
| `chatwoot-fix/config/routes.rb` | Rotas (inclui `post :forward` e `post :create_group` — a base v4.14.2 não tem) |
| `chatwoot-fix/app/services/whatsapp/incoming_message_base_service.rb` | Sanitização de filename de anexos recebidos (corta o sufixo `;filename*=`) — v4.17.6 |
| `chatwoot-fix/app/services/messages/in_reply_to_message_builder.rb` | Reply/quote resolve mensagens citadas de conversas ANTIGAS do contato + expõe `in_reply_to_conversation_id` — v4.17.6 |
| `chatwoot-fix/InternalChatLayout.vue` | Componente corrigido (scroll + merge + caixa nova + menu de contexto + **Responder** + edição melhorada + **links clicáveis** + **forward** + **emoji** + **Selecionar no menu** + **separador de data sticky por dia** + **`+` = conversa direta + botão 👥 Novo Grupo** + **fix ícone 👥** `icon="people"`) — referência |
| `chatwoot-fix/message/Message.vue` | Componente do chat do cliente com **duplo clique para responder** — referência |
| `chatwoot-fix/message/MessageList.vue` | Prévia de reply/quote busca da conversa certa (`in_reply_to_conversation_id`) — v4.17.6 |
| `chatwoot-fix/message/bubbles/Base.vue` | Clique na citação de outra conversa navega até ela (`?messageId=`) — v4.17.6 |
| `chatwoot-fix/copilot/CopilotLauncher.vue` | Launcher do Copiloto — **sobe no Chat Interno** para não tampar o botão de enviar (v4.17.2) |
| `README.md` | Este documento |

---

## 🧠 Contexto do Chat Interno (referência)

O "Chat Interno" é uma customização do Chatwoot onde agentes conversam entre si (mensagens `message_type: :internal`, marcadas com `conversations.internal = true` e `participant_ids` em `additional_attributes`). O controller principal é `app/controllers/api/v1/accounts/internal_chat_controller.rb`.

