# 🐱‍💻 AutoFlow

> 🌐 [Ler em português](./README.md)

Mobile app for freight brokerage, with fixed pricing, secure in-app chat, and proof of delivery (POD). Capstone project (Projeto Integrador) for the Software Engineering program at UniEVANGÉLICA, Anápolis, Brazil.

---

## 📦 About the project

AutoFlow connects companies that need to ship cargo (shippers) with independent truck drivers and small carriers, addressing three problems in the road freight sector:

- 🔄 **Empty return trips** — trucks driving back empty after a delivery, wasting revenue.
- 🔒 **Legal uncertainty on delivery** — no reliable proof that cargo arrived intact.
- 📋 **Hiring bureaucracy** — informal, untraceable negotiations, usually done through WhatsApp groups.

The solution is a digital marketplace with fixed pricing (no bidding), mandatory in-app chat, and a proof-of-delivery system based on seal photos and geolocation — the **"Seal Rule"**.

---

## 🛠️ Tech stack

| Layer | Technology |
|---|---|
| Backend | Java + Spring Boot |
| Database | PostgreSQL |
| Hosting | Supabase |
| Mobile frontend | *(to be defined by the team)* |

---

## 📁 Repository structure

```
autoflow/
├── database/       # SQL scripts to create the database (PostgreSQL)
├── backend/        # Backend code (Spring Boot)
└── README.md
```

> 📌 The project's academic documentation is not in this repository yet.

---

## 🗄️ Database

The full database creation script is at [`database/autoflow_database.sql`](./database/autoflow_database.sql). To run it locally:

```bash
psql -U your_user -d autoflow -f database/autoflow_database.sql
```

The model covers business rules RN-001 through RN-013 from the project documentation, including shipper/driver/carrier registration, freight publication, trip acceptance and execution, payment escrow, proof of delivery (POD), and dispute handling.

---

## 👥 Team

| Role | Member |
|---|---|
| Product Owner / Database Architect / Backend | João Marcos de Almeida Rodrigues |
| UX/UI Designer | Fellype Eduardo De Souza Neves |
| UX/UI Designer | Guilherme Augusto Almeida Felício |
| UX Researcher / Business Analyst | Matheus Rodrigues Rocha Tavares |

**Advisors:** Renato Luan (primary) · Jefferson (secondary)

---

## 🤝 Contributing

1. Clone the repository: `git clone https://github.com/your-username/autoflow.git`
2. Create a branch for your task: `git checkout -b task-name`
3. Commit your changes: `git commit -m "change description"`
4. Push to GitHub: `git push origin task-name`
5. Open a Pull Request for team review before merging into `main`

---

## 📄 License

Academic project — restricted use for the Projeto Integrador course at UniEVANGÉLICA.
