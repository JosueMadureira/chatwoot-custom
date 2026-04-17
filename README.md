# Chatwoot Custom

**Versão customizada do Chatwoot com melhorias focadas na experiência do agente.**

[![Docker Pulls](https://img.shields.io/docker/pulls/josuemadureira/chatwoot-custom)](https://hub.docker.com/r/josuemadureira/chatwoot-custom)

---

## ✨ Funcionalidades Implementadas

### v1.2 – Notificações Inteligentes (Recomendada)
- **Título da notificação**: Nome do contato (ex: “João Silva”)
- **Corpo da notificação**: Prévia real da última mensagem recebida
- Se for apenas anexo → mostra “Enviou um anexo”
- Comportamento igual ao **WhatsApp** e **Telegram**
- Funciona perfeitamente no navegador (Service Worker) e no app mobile
- Removeu completamente o antigo texto “A new message is created in conversation (#ID)”

### v1 – Bloqueio de Atendimentos Duplicados
- Impede que dois agentes atendam o mesmo cliente ao mesmo tempo
- Remove conversas duplicadas da inbox automaticamente
- Evita conflitos e bagunça nos atendimentos

## 📦 Como usar com Docker

### Versão recomendada (v1.2)
```bash
docker pull josuemadureira/chatwoot-custom:v1.2
