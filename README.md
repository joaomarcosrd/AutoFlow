# 🐱‍💻 AutoFlow

> 🌐 [Read in English](./README.en.md)

Aplicativo mobile de intermediação de fretes rodoviários, com preço fixo, chat seguro e comprovação de entrega (POD). Projeto Integrador do curso de Engenharia de Software — UniEVANGÉLICA, Anápolis/GO.

---

## 📦 Sobre o projeto

O AutoFlow conecta empresas que precisam enviar cargas (embarcadores) a motoristas autônomos e transportadoras, resolvendo três problemas do setor:

- 🔄 **Frete de retorno** — caminhões que voltam vazios após a entrega, gerando prejuízo.
- 🔒 **Insegurança jurídica na entrega** — falta de comprovação confiável de que a carga chegou intacta.
- 📋 **Burocracia na contratação** — negociação informal e sem rastreabilidade, geralmente feita por grupos de WhatsApp.

A solução é uma vitrine digital com preço fixo (sem leilão), chat interno obrigatório e um sistema de comprovação de entrega baseado em fotos do lacre e geolocalização — a chamada **"Regra do Lacre"**.

---

## 🛠️ Stack tecnológica

| Camada | Tecnologia |
|---|---|
| Backend | Java + Spring Boot |
| Banco de dados | PostgreSQL |
| Hospedagem | Supabase |
| Frontend mobile | *(a definir pela equipe)* |

---

## 📁 Estrutura do repositório

```
autoflow/
├── database/       # Scripts SQL de criação do banco (PostgreSQL)
├── backend/        # Código do backend (Spring Boot)
└── README.md
```

> 📌 A documentação do Projeto Integrador ainda não está neste repositório.

---

## 🗄️ Banco de dados

O script completo de criação do banco está em [`database/autoflow_database.sql`](./database/autoflow_database.sql). Para rodar localmente:

```bash
psql -U seu_usuario -d autoflow -f database/autoflow_database.sql
```

O modelo cobre as regras de negócio RN-001 a RN-013 descritas na documentação, incluindo cadastro de embarcadores/motoristas/transportadoras, publicação de fretes, aceite e execução de viagens, retenção de pagamento, comprovação de entrega (POD) e abertura de disputas.

---

## 👥 Equipe

| Função | Integrante |
|---|---|
| Product Owner / Arquiteto de Banco de Dados / Backend | João Marcos de Almeida Rodrigues |
| UX/UI Designer | Fellype Eduardo De Souza Neves |
| UX/UI Designer | Guilherme Augusto Almeida Felício |
| UX Researcher / Analista de Negócios | Matheus Rodrigues Rocha Tavares |

**Orientação:** Renato Luan (principal) · Jefferson (secundário)

---

## 🤝 Como contribuir

1. Clone o repositório: `git clone https://github.com/seu-usuario/autoflow.git`
2. Crie uma branch para sua tarefa: `git checkout -b nome-da-tarefa`
3. Faça suas alterações e commit: `git commit -m "descrição da alteração"`
4. Envie para o GitHub: `git push origin nome-da-tarefa`
5. Abra um Pull Request para revisão da equipe antes de mesclar na `main`

---

## 📄 Licença

Projeto acadêmico — uso restrito à disciplina de Projeto Integrador da UniEVANGÉLICA.
