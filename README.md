# Chatwoot Custom

**Versão customizada do Chatwoot com melhorias focadas na experiência do agente.**

[![Docker Pulls](https://img.shields.io/docker/pulls/josuemadureira/chatwoot-custom)](https://hub.docker.com/r/josuemadureira/chatwoot-custom)

---

## ✨ Funcionalidades Implementadas

### v1 – Bloqueio de Atendimentos Duplicados (Lock de Conversas)
- Impede que **dois agentes atendam o mesmo cliente ao mesmo tempo**
- Remove conversas duplicadas da inbox automaticamente
- Elimina conflitos operacionais e inconsistência de dados

**Versão base**: Chatwoot oficial **v4.12.1**

### v1.2 – Notificações Inteligentes (em breve)
Notificações como WhatsApp/Telegram (nome do contato + prévia da mensagem).

## 📦 Como usar (Docker)

### Versão v1 (Bloqueio de duplicidade)
```bash
docker pull josuemadureira/chatwoot-custom:v1
