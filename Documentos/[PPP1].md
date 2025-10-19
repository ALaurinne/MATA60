# [PPP1] Política de Preservação de Privacidade para Bancos de Dados - Modelo 1

# **1. Objetivo**

Garantir a segurança, privacidade e rastreabilidade dos dados, definindo níveis de acesso restritos e requisitos de auditoria para todas as ações realizadas no banco de dados, em conformidade com a **LGPD** e regulamentações de segurança.

# **2. Níveis de Acesso, Permissões e Requisitos de Auditoria**

| **Nível de Acesso** | **Função** | **Permissões** | **Eventos Auditados** |
| --- | --- | --- | --- |
| **DBA (Admin)** | Administrador do Banco | - Acesso total (DDL, DML, DCL).
- Gerenciamento de usuários, roles, backups. | **Todas as ações**:
- CREATE, ALTER, DROP.- GRANT/REVOKE.
- Acesso a tabelas sensíveis.
- Logins bem-sucedidos e falhos. |
| **Sistema** | Aplicação/Serviço | - Executar DML (INSERT, UPDATE, DELETE).
- Acesso a procedures, triggers, transações. | **Operações críticas**:
- Modificações em dados (INSERT/UPDATE/DELETE).- Execução de stored procedures.
- Tentativas de acesso a objetos não autorizados. |
| **Análise** | Analista de Dados | - SELECT em tabelas e views.
- Consulta a materialized views. | **Consultas a dados sensíveis**:- Acesso a PII (dados pessoais).
- Consultas com alto consumo de recursos. |
| **Backup** | Operador de Backup | - Executar backups (leitura total).
- Nenhuma modificação. | **Eventos de backup**:
- Início/término de backups.
- Falhas durante o processo.
- Tentativas de acesso a dados fora do escopo. |

# **3. Controles de Auditoria**

Todos os eventos devem ser registrados em **pgAudit** ou tabelas dedicadas.