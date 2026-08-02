# Chatwoot Custom

**Versão customizada do Chatwoot com melhorias focadas na experiência do agente.**

[![Docker Pulls](https://img.shields.io/docker/pulls/josemadureira/chatwoot-custom)](https://hub.docker.com/r/josemadureira/chatwoot-custom)

---

## 📌 Imagens Docker disponíveis

| Imagem | Descrição |
|---|---|
| `josuemadureira/chatwoot-custom:v4.14.4` | **Atual** — v4.14.3 + melhorias visuais do Chat Interno (balões/avatares iguais ao cliente, checks ✓✓ entregue/lido, colar imagem com Ctrl+V) |
| `josuemadureira/chatwoot-custom:v4.14.3` | v4.14.2 + correção dos 3 bugs do Chat Interno |
| `josuemadureira/chatwoot-custom:v4.14.2` | Produção em uso até 2026-08-02 (sem as correções) |
| `josuemadureira/chatwoot-custom:v1.2` | Versão antiga (Notificações Inteligentes) |

```bash
# Baixar a imagem atual
docker pull josuemadureira/chatwoot-custom:v4.14.3
```

---

## ✨ Funcionalidades Implementadas

### v4.14.3 – Correção dos bugs do Chat Interno (2026-08-02)

**Base:** `josuemadureira/chatwoot-custom:v4.14.2` (NÃO é um build novo — é um overlay que só acrescenta os arquivos corrigidos por cima da base, sem tocar no banco).

Três bugs foram corrigidos:

#### 🐛 Bug 1 — Mensagem some no Chat Interno (só aparece na notificação)
- **Sintoma:** em conversas internas com mais de 100 mensagens, as novas mensagens não aparecem no chat — só chegam via notificação.
- **Causa:** a action `messages` usava `.order(created_at: :asc).limit(100)` → retornava as **100 mensagens mais antigas**, escondendo as novas.
- **Correção:** `.order(created_at: :desc).limit(100).reverse` → mostra as **100 mais recentes** em ordem de exibição (mesmo padrão do `message_finder.rb`).
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
docker build -t josuemadureira/chatwoot-custom:v4.14.3 .

# 3. Push para o Docker Hub
docker login -u josuemadureira
docker push josuemadureira/chatwoot-custom:v4.14.3
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
2. No compose, troque `v4.14.2` → `v4.14.3` em `chatwoot_app` e `chatwoot_sidekiq`.
3. Suba apenas os serviços alterados (Postgres/Redis ficam intocados):

```bash
docker compose -f <caminho-compose> -p chatwoot up -d chatwoot_app chatwoot_sidekiq
```

4. Verifique: `curl localhost:3000` (esperado `301`) + `docker ps`.

---

## 📁 Estrutura deste repositório

| Pasta/Arquivo | Conteúdo |
|---|---|
| `chatwoot-fix/Dockerfile` | Overlay da imagem v4.14.3 |
| `chatwoot-fix/internal_chat_controller.rb` | Controller corrigido (bugs 1 e 2) |
| `chatwoot-fix/InternalChatLayout.vue` | Componente corrigido (bug 3) — referência |
| `README.md` | Este documento |

---

## 🧠 Contexto do Chat Interno (referência)

O "Chat Interno" é uma customização do Chatwoot onde agentes conversam entre si (mensagens `message_type: :internal`, marcadas com `conversations.internal = true` e `participant_ids` em `additional_attributes`). O controller principal é `app/controllers/api/v1/accounts/internal_chat_controller.rb`.
