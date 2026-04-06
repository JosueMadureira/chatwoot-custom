# Chatwoot Custom (Lock de Conversas)

Versão customizada do Chatwoot com bloqueio de atendimentos duplicados por contato na mesma inbox.

---

## 🚀 Funcionalidade principal

Impede que dois agentes iniciem atendimento simultaneamente para o mesmo contato na mesma inbox.

---

## 🧠 Como funciona

* Validação no backend antes de criar conversa
* Retorno HTTP 422 quando já existe atendimento aberto
* Tratamento de concorrência (race condition)
* Feedback no frontend para o agente

---

## 💥 Problema que resolve

Evita:

* conversas duplicadas
* conflito entre atendentes
* inconsistência de dados

---

## 📦 Uso

```bash
docker pull josuemadureira/chatwoot-custom:v1
```

```yaml
services:
  chatwoot_app:
    image: josuemadureira/chatwoot-custom:v1
```

---

## ⚙️ Requisitos

* Docker
* Banco já existente (Postgres)
* Redis

---

## ⚠️ Observações

* Requer migrations aplicadas
* Não remove dados existentes
* Compatível com ambiente já em produção

---

## 🔄 Versões

### v1

* Implementação do bloqueio de atendimentos duplicados

---

## 📌 Base

Baseado no Chatwoot oficial V4.12.1

---

## 👨‍💻 Autor

Josué Madureira
