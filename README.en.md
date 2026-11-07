# 🚛 💻 AutoFlow

> 🌐 [Ler em Português](README.md)

Web/mobile logistics brokerage application focused on connecting **shipper companies** with **independent truck drivers** and **carriers** quickly, traceably, and securely, featuring **fixed pricing**, **mandatory internal chat**, and **Proof of Delivery (POD)** based on the **"Seal Rule" (*Regra do Lacre*)**.

Capstone Project (*Projeto Integrador*) for the **Software Engineering** degree (4th Semester) — **UniEVANGÉLICA**, Anápolis/GO, Brazil.

---

## 📦 About the Project

**AutoFlow** operates in the road freight transport sector (initially focused on the State of Goiás), solving three critical bottlenecks in the logistics chain:

- 🔄 **Empty backhauls (logistics idleness)** — truck drivers and carriers making return trips with empty vehicles due to lack of visibility or fear of transporting cargo without legal backing.
- 🔒 **Legal uncertainty in deliveries** — lack of standardized, reliable proof that the truck body arrived unviolated at the final destination, causing drivers to bear undue financial losses.
- 📋 **Contracting bureaucracy and informality** — decentralized, untraceable negotiations (usually conducted in WhatsApp groups), subject to predatory bidding wars and communication breakdowns.

### 💡 Solution Pillars (MVP)
1. **Fixed-Price Digital Marketplace (`RN-005`, `RN-006`):** The shipper sets the final freight price upon publication, with no auctions or bargaining, and allocation occurs on a first-accept basis (`RN-007`).
2. **Progressive Disclosure & Payment Retention (`RN-008`, `RN-009`):** The exact pickup address and the **auditable internal chat** are only unlocked after the driver accepts the trip and payment retention is confirmed.
3. **"Seal Rule" Protocol & Proof Vault — POD (`RN-010` to `RN-013`):** Mandatory photographic registration of the numbered seal and cargo invoice (NF/CT-e) at pickup (check-in), geolocation (GPS) validation upon arrival, and intact seal photo + signed delivery receipt at drop-off (check-out).
4. **Automated Document Validation & Blocking (`RN-003`, `RN-004`):** Automated expiration monitoring for driver licenses (CNH) and vehicle registrations (CRLV), notifying drivers 3 months in advance and automatically blocking accounts with expired documentation.

---

## 🔗 Project Artifacts & Documentation

| Artifact | Access Link | Description |
| :--- | :--- | :--- |
| 🎨 **Interface Prototype (UI/UX)** | [Open in Figma](https://www.figma.com/design/6lhHudd9Qzx3K3tQSBbVyi/Auto-Flow--c%C3%B3pia-?node-id=2019-284) | Navigation screens (Shipper and Driver), *Mobile-First* design, and linear pickup/delivery flows |
| 🗂️ **Database Diagram (ERD)** | [Open in Google Drive](https://drive.google.com/file/d/1nXA-ZCv7e4Cra6UTwZK7n0j-vBo8o3Sa/view?usp=sharing) | Complete Entity-Relationship Model (Version 2.2) |
| 📜 **SQL Script (Flyway Migration)** | [`V1__init_schema.sql`](src/main/resources/db/migration/V1__init_schema.sql) | Complete DDL for tables, `ENUM` types, and constraints in PostgreSQL |

---

## 🛠️ Tech Stack

| Layer | Technology | Justification / Role in the System |
| :--- | :--- | :--- |
| **Language & Runtime** | **Java 21 (LTS)** | Strong typing, `records` support, and high transactional reliability |
| **Backend Framework** | **Spring Boot 3.3.5** | RESTful API, Spring Web, Spring Data JPA, Validation, and scheduling (`@Scheduled`) |
| **Database** | **PostgreSQL 17 (Supabase)** | ACID compliance, referential integrity, and native `UUID` and `ENUM` support |
| **DB Versioning** | **Flyway** | Automated execution and validation of SQL migrations on startup |
| **Cloud Storage** | **Supabase Storage / S3** | External storage for heavy media (seal photos, CNH, and receipts), storing only URLs in the database (`RNF-01`, `RNF-05`) |
| **Quality & Standards** | **Spotless + EditorConfig + Lombok** | Automated formatting (`palantir-java-format`) during the Maven build cycle |
| **Automated Testing** | **JUnit 5 + Spring MockMvc** | Integration tests to validate endpoints and Supabase connectivity |
| **Mobile/Web Frontend** | *(Being defined by the team)* | *Mobile-First* interface for drivers and responsive dashboard for shippers (`RNF-02`) |

---

## 📁 Repository Structure

The backend codebase is organized into modular packages that directly reflect the data model domains:

```text
AutoFlow/
├── .mvn/wrapper/                         # Maven Wrapper (ensures the same Maven version across the team)
├── src/
│   ├── main/
│   │   ├── java/br/com/autoflow/
│   │   │   ├── auth/                     # Authentication, password hashing (RNF-03), and access control
│   │   │   ├── avaliacao/                # Mutual ratings after trip completion
│   │   │   ├── chat/                     # Restricted, auditable internal chat (RN-009)
│   │   │   ├── documento/                # Document management and validation (CNH, CRLV, RNTRC, CNPJ)
│   │   │   ├── frete/                    # Open fixed-price freight marketplace (RN-005, RN-006)
│   │   │   ├── notificacao/              # System alerts and expiration warnings (RN-004)
│   │   │   ├── nucleo/                   # Global configurations, exception handling, and utilities
│   │   │   ├── pagamento/                # Escrow retention and payment release control (RN-008)
│   │   │   ├── prova/                    # POD evidence vault, geolocation, and Seal Rule (RN-010 to RN-012)
│   │   │   ├── status/                   # Database health and diagnostic endpoint (/api/status)
│   │   │   ├── usuario/                  # Profiles: Shipper (Company), Independent Driver, and Carrier (RN-001, RN-002)
│   │   │   ├── veiculo/                  # Vehicle registration and CRLV expiration control
│   │   │   ├── viagem/                   # Trip lifecycle, status history, and disputes (RN-013)
│   │   │   └── AutoFlowApplication.java  # Main Spring Boot application class
│   │   └── resources/
│   │       ├── db/migration/
│   │       │   └── V1__init_schema.sql   # Initial database migration managed by Flyway
│   │       └── application.yml           # DataSource (HikariCP), JPA/Hibernate, and Flyway settings
│   └── test/
│       └── java/br/com/autoflow/
│           └── status/
│               └── StatusControllerTest.java # Integration test for GET /api/status
├── .editorconfig                         # Code style and UTF-8 encoding rules
├── pom.xml                               # Maven dependencies and plugins (Spring Boot, Spotless, Lombok)
├── README.md                             # Main documentation (Portuguese)
└── README.en.md                          # Documentation in English
```

---

## 🗄️ Database Architecture

The relational model (implemented in [`V1__init_schema.sql`](src/main/resources/db/migration/V1__init_schema.sql)) is structured around five core domains:

1. **Actor Isolation:** The `usuario` table centralizes credentials (`senha_hash`), phone numbers, and **LGPD** consent (`aceite_lgpd`, `aceite_lgpd_em` — `RNF-04`). The `embarcador`, `transportadora`, and `motorista` tables inherit this identity, while `veiculo` and `documento` track licenses and expiration dates.
2. **Demand Generation:** The `frete`, `endereco`, and `categoria_carga` tables store fixed-price offers along with origin and destination geographic coordinates.
3. **Operational Control:** The `viagem` table links the accepted freight to the driver and vehicle, paired with the `pagamento` table (statuses: `PENDENTE`, `RETIDO`, `LIBERADO`, `ESTORNADO`).
4. **Proof Vault (POD):** The `comprovante_pod` table records media URLs (`COLETA`, `ENTREGA`, `CANHOTO`), metadata, and geolocation without bloating the relational database with heavy binary files.
5. **Legal Security & Auditing:** The `disputa`, `historico_status_viagem`, `mensagem_chat`, `avaliacao`, and `notificacao` tables ensure end-to-end traceability.

---

## 🚀 How to Run the Project

### 1. Configure environment variables (`.env`)
Create a `.env` file in the project root with the **Supabase** PostgreSQL JDBC credentials:

```env
DB_URL=jdbc:postgresql://aws-0-us-east-1.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0
DB_USERNAME=postgres.zrpqeuzcabqjcajtjksy
DB_PASSWORD=YOUR_PASSWORD_HERE
```

### 2. Start the Spring Boot application
The `application.yml` file automatically imports `.env`. Simply run:

```bash
./mvnw spring-boot:run
```

### 3. Test the Diagnostic Endpoint (`GET /api/status`)
With the server running on port `8080`, open `http://localhost:8080/api/status` in your browser or run:

```bash
curl http://localhost:8080/api/status
```

**Sample response (`HTTP 200 OK`):**
```json
{
  "updated_at": "2026-11-07T17:28:22.452890847Z",
  "dependencies": {
    "database": {
      "version": "17.11",
      "max_connections": 60,
      "opened_connections": 11
    }
  }
}
```

### 4. Run Tests & Code Formatting
```bash
# Run the integration test suite (JUnit 5 + MockMvc)
./mvnw test

# Apply automated code formatting (Spotless / Palantir Java Format)
./mvnw spotless:apply
```

---

## 👥 Project Team

| Student ID | Member | Role in Project |
| :---: | :--- | :--- |
| **2512207** | **João Marcos de Almeida Rodrigues** | Product Owner (PO) / Back-end & Database Developer / Documentation & QA |
| **2512329** | **Fellype Eduardo De Souza Neves** | UX/UI Designer / Front-end Developer |
| **2512692** | **Guilherme Augusto Almeida Felício** | UX/UI Designer / Front-end Developer |
| **2511417** | **Matheus Rodrigues Rocha Tavares** | UX Researcher / Business Analyst / Back-end Developer |

**Faculty Advisors:**
- **Lead Advisor:** Prof. Luan Cardoso De Jesus
- **Co-Advisor:** Prof. Eduardo Dias Pereira

---

## 📄 License

Academic project distributed under the [MIT License](LICENSE) — restricted to the **Capstone Project (*Projeto Integrador*)** course of the Software Engineering program at **UniEVANGÉLICA**.
