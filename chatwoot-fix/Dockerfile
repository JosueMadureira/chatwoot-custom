FROM josuemadureira/chatwoot-custom:v4.14.2
# Correções dos bugs 1 e 2 (backend): mensagem some + preferência de notificação re-marca sozinha
COPY internal_chat_controller.rb /app/app/controllers/api/v1/accounts/internal_chat_controller.rb
# Correção do bug 3 (frontend): chat interno abre na última mensagem, como WhatsApp
# Assets Vite recompilados no notebook (Node 24 + pnpm 10 + vite 6.4.2), 57s de build
COPY public/vite/ /app/public/vite/
