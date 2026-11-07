# 🚛 💻 AutoFlow

> 🌐 [Read in English](README.en.md)

Aplicativo web/mobile de intermediação logística focado em conectar **empresas embarcadoras** a **motoristas autônomos** e **transportadoras** de forma rápida, rastreável e segura, com **preço fixo**, **chat interno obrigatório** e **comprovação de entrega (POD — *Proof of Delivery*)** baseada na **"Regra do Lacre"**.

Projeto Integrador do curso de **Engenharia de Software (4º Período) — UniEVANGÉLICA**, Anápolis/GO.

---

## 📦 Sobre o Projeto

O **AutoFlow** atua no setor de transporte rodoviário de cargas (com foco inicial no Estado de Goiás), solucionando três gargalos críticos da cadeia logística:

- 🔄 **Frete de retorno (ociosidade logística)** — caminhoneiros e transportadoras que realizam viagens de volta com os veículos vazios por falta de visibilidade ou receio de transportar cargas sem respaldo jurídico.
- 🔒 **Insegurança jurídica na entrega** — ausência de comprovação padronizada e confiável de que o baú chegou inviolado ao destino final, fazendo com que motoristas assumam prejuízos indevidos.
- 📋 **Burocracia e informalidade na contratação** — negociações descentralizadas e sem rastreabilidade (geralmente em grupos de WhatsApp), sujeitas a leilões predatórios e falhas de comunicação.

### 💡 Pilares da Solução (MVP)
1. **Vitrine Digital com Preço Fixo (`RN-005`, `RN-006`):** O embarcador define o valor final do frete na publicação, sem leilões ou barganhas, e a alocação ocorre por ordem de aceite (`RN-007`).
2. **Divulgação Progressiva e Retenção de Pagamento (`RN-008`, `RN-009`):** O endereço exato de coleta e o **chat interno auditável** só são liberados após o aceite do motorista e a confirmação da retenção do pagamento.
3. **Protocolo da "Regra do Lacre" e Cofre de Provas — POD (`RN-010` a `RN-013`):** Registro fotográfico obrigatório do lacre numerado e da NF/CT-e na coleta (check-in), validação via geolocalização (GPS) na chegada e foto do lacre intacto + canhoto assinado na entrega (check-out).
4. **Validação e Bloqueio Automático de Documentos (`RN-003`, `RN-004`):** Monitoramento automático da validade de CNH e CRLV, notificando o condutor com 3 meses de antecedência e bloqueando contas com documentação expirada.

---

## 🔗 Artefatos e Documentação do Projeto

| Artefato | Link de Acesso | Descrição |
| :--- | :--- | :--- |
| 🎨 **Protótipo de Interface (UI/UX)** | [Acessar no Figma](https://www.figma.com/design/6lhHudd9Qzx3K3tQSBbVyi/Auto-Flow--c%C3%B3pia-?node-id=2019-284) | Telas de navegação (Embarcador e Motorista), design *Mobile-First* e fluxos lineares de coleta/entrega |
| 🗂️ **Diagrama do Banco de Dados (MER)** | [Acessar no Google Drive](https://drive.google.com/file/d/1nXA-ZCv7e4Cra6UTwZK7n0j-vBo8o3Sa/view?usp=sharing) | Modelo Entidade-Relacionamento completo (Versão 2.2) |
| 📜 **Script SQL (Flyway Migration)** | [`V1__init_schema.sql`](src/main/resources/db/migration/V1__init_schema.sql) | DDL completo das tabelas, tipos `ENUM` e constraints no PostgreSQL |

---

## 🛠️ Stack Tecnológica

| Camada | Tecnologia | Justificativa / Papel no Sistema |
| :--- | :--- | :--- |
| **Linguagem & Runtime** | **Java 21 (LTS)** | Tipagem forte, suporte a `records` e alta confiabilidade transacional |
| **Framework Backend** | **Spring Boot 3.3.5** | API RESTful, Spring Web, Spring Data JPA, Validation e agendamento (`@Scheduled`) |
| **Banco de Dados** | **PostgreSQL 17 (Supabase)** | Conformidade ACID, integridade referencial e suporte nativo a `UUID` e `ENUM` |
| **Versionamento de DB** | **Flyway** | Execução e validação automatizada de migrações SQL na inicialização |
| **Cloud Storage** | **Supabase Storage / S3** | Armazenamento externo de mídias pesadas (fotos de lacres, CNH e canhotos), mantendo apenas URLs no banco (`RNF-01`, `RNF-05`) |
| **Qualidade & Padrão** | **Spotless + EditorConfig + Lombok** | Formatação automática (`palantir-java-format`) no ciclo de compilação do Maven |
| **Testes Automatizados** | **JUnit 5 + Spring MockMvc** | Testes de integração para validação das rotas e comunicação com o Supabase |
| **Frontend Mobile/Web** | *(Em definição pela equipe)* | Interface *Mobile-First* para motoristas e painel responsivo para embarcadores (`RNF-02`) |

---

## 📁 Estrutura do Repositório

O código do backend está organizado em pacotes modulares que refletem diretamente os domínios do modelo de dados:

```text
AutoFlow/
├── .mvn/wrapper/                         # Maven Wrapper (garante a mesma versão do Maven para a equipe)
├── src/
│   ├── main/
│   │   ├── java/br/com/autoflow/
│   │   │   ├── auth/                     # Autenticação, hash de senhas (RNF-03) e controle de acesso
│   │   │   ├── avaliacao/                # Avaliação bilateral após encerramento de viagens
│   │   │   ├── chat/                     # Chat interno restrito e auditável (RN-009)
│   │   │   ├── documento/                # Gestão e validação de documentos (CNH, CRLV, RNTRC, CNPJ)
│   │   │   ├── frete/                    # Vitrine aberta de fretes com preço fixo (RN-005, RN-006)
│   │   │   ├── notificacao/              # Alertas do sistema e avisos de vencimento (RN-004)
│   │   │   ├── nucleo/                   # Configurações globais, tratamento de exceções e utilitários
│   │   │   ├── pagamento/                # Controle de retenção (Escrow) e liberação de valores (RN-008)
│   │   │   ├── prova/                    # Cofre de provas POD, geolocalização e Regra do Lacre (RN-010 a RN-012)
│   │   │   ├── status/                   # Endpoint de diagnóstico e saúde do banco (/api/status)
│   │   │   ├── usuario/                  # Perfis: Embarcador (PJ), Motorista Autônomo e Transportadora (RN-001, RN-002)
│   │   │   ├── veiculo/                  # Cadastro de veículos e controle de validade do CRLV
│   │   │   ├── viagem/                   # Ciclo de vida da viagem, histórico de status e disputas (RN-013)
│   │   │   └── AutoFlowApplication.java  # Classe principal de inicialização do Spring Boot
│   │   └── resources/
│   │       ├── db/migration/
│   │       │   └── V1__init_schema.sql   # Migração inicial do banco gerenciada pelo Flyway
│   │       └── application.yml           # Configurações de DataSource (HikariCP), JPA/Hibernate e Flyway
│   └── test/
│       └── java/br/com/autoflow/
│           └── status/
│               └── StatusControllerTest.java # Teste de integração do endpoint GET /api/status
├── .editorconfig                         # Regras de estilo e codificação UTF-8
├── pom.xml                               # Gerenciamento de dependências e plugins (Spring Boot, Spotless, Lombok)
├── README.md                             # Documentação principal (Português)
└── README.en.md                          # Documentação em Inglês
```

---

## 🗄️ Arquitetura do Banco de Dados

O modelo relacional (implementado em [`V1__init_schema.sql`](src/main/resources/db/migration/V1__init_schema.sql)) é estruturado em cinco núcleos:

1. **Isolamento de Atores:** A tabela `usuario` centraliza credenciais (`senha_hash`), telefone e consentimento da **LGPD** (`aceite_lgpd`, `aceite_lgpd_em` — `RNF-04`). As tabelas `embarcador`, `transportadora` e `motorista` herdam essa identidade, enquanto `veiculo` e `documento` controlam as habilitações e validades.
2. **Geração de Demanda:** As tabelas `frete`, `endereco` e `categoria_carga` armazenam as ofertas com preço fixo e coordenadas geográficas de origem e destino.
3. **Controle Operacional:** A tabela `viagem` conecta o frete aceito ao motorista e veículo, acompanhada pela tabela `pagamento` (status `PENDENTE`, `RETIDO`, `LIBERADO`, `ESTORNADO`).
4. **Cofre de Provas (POD):** A tabela `comprovante_pod` registra as URLs das mídias (`COLETA`, `ENTREGA`, `CANHOTO`), metadados e geolocalização, sem sobrecarregar o banco com binários pesados.
5. **Segurança Jurídica e Auditoria:** As tabelas `disputa`, `historico_status_viagem`, `mensagem_chat`, `avaliacao` e `notificacao` garantem rastreabilidade completa de ponta a ponta.

---

## 🚀 Como Executar o Projeto

### 1. Configurar variáveis de ambiente (`.env`)
Crie um arquivo `.env` na raiz do projeto com as credenciais JDBC do PostgreSQL no **Supabase**:

```env
DB_URL=jdbc:postgresql://aws-0-us-east-1.pooler.supabase.com:5432/postgres?sslmode=require&prepareThreshold=0
DB_USERNAME=postgres.zrpqeuzcabqjcajtjksy
DB_PASSWORD=SUA_SENHA_AQUI
```

### 2. Iniciar a aplicação Spring Boot
O arquivo `application.yml` importa automaticamente o `.env`. Basta executar:

```bash
./mvnw spring-boot:run
```

### 3. Testar o Endpoint de Diagnóstico (`GET /api/status`)
Com o servidor ativo na porta `8080`, acesse `http://localhost:8080/api/status` no navegador ou via terminal:

```bash
curl http://localhost:8080/api/status
```

**Exemplo de resposta (`HTTP 200 OK`):**
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

### 4. Executar Testes e Padronização de Código
```bash
# Executar a suíte de testes de integração (JUnit 5 + MockMvc)
./mvnw test

# Aplicar formatação automática de código (Spotless / Palantir Java Format)
./mvnw spotless:apply
```

---

## 👥 Equipe do Projeto

| Matrícula | Integrante | Função no Projeto |
| :---: | :--- | :--- |
| **2512207** | **João Marcos de Almeida Rodrigues** | Product Owner (PO) / Desenvolvedor Back-end e Banco de Dados / Documentação e Qualidade (QA) |
| **2512329** | **Fellype Eduardo De Souza Neves** | UX/UI Designer / Desenvolvedor Front-end |
| **2512692** | **Guilherme Augusto Almeida Felício** | UX/UI Designer / Desenvolvedor Front-end |
| **2511417** | **Matheus Rodrigues Rocha Tavares** | UX Researcher / Analista de Negócios / Desenvolvedor Back-end |

**Professores Orientadores:**
- **Orientador Principal:** Prof. Luan Cardoso De Jesus
- **Orientador Secundário:** Prof. Eduardo Dias Pereira

---

## 📄 Licença

Projeto acadêmico distribuído sob a licença [MIT](LICENSE) — uso restrito à disciplina de **Projeto Integrador** do curso de Engenharia de Software da **UniEVANGÉLICA**.
