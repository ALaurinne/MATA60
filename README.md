# [PRJ5] Sistema para Revisões Sistemáticas da Literatura (MATA60-BD)

## 1. Introdução e Contexto do Projeto

Este projeto consiste na elaboração, modelagem, implantação e otimização de um Banco de Dados para dar suporte a um **Sistema de Gerenciamento de Revisões Sistemáticas da Literatura**. O objetivo é gerenciar eficientemente o fluxo de trabalho de pesquisadores na coleta, classificação, revisão por pares e análise de um grande volume de artigos científicos.

### Requisitos Atendidos (Original e Extendido)

| Categoria | Requisito Principal | Extensão Aplicada |
| :--- | :--- | :--- |
| **Coleta** | R1: Cadastrar artigos com metadados. | R1.1: Rastreamento de múltiplas **Bases de Dados** de origem (`TB_BASE_DADO`). |
| **Classificação** | R2: Classificação por critérios de inclusão/exclusão. | Classificação unificada em `TB_CRITERIO` (Inclusão/Exclusão). |
| **Revisão** | R4: Controlar a revisão por pares. | R4.1: Gestão de artigos dentro de **Projetos/Revisões** específicos (`TB_PROJETO`). |
| **Avaliação** | R3: Registrar notas e avaliações de pesquisadores. | Auditoria de conflito de interesse (Revisor vs. Autor). |
| **Análise** | R5: Gerar estatísticas. | Geração de relatórios complexos (30 consultas) sobre tendências e desempenho. |

## 2. Modelagem do Banco de Dados

### 2.1. Metodologia (MAD)

Toda a modelagem e implementação seguiu a **Metodologia de Administração de Dados (MAD) Modelo IBA**, conforme documentado em `# [MAD1] Metodologia baseada no IBA.txt`.

**Padrões Chave:**
* **Nomenclatura:** `PREFIXO_NOMEOBJETO` (ex: `TB_ARTIGO`, `RL_ARTIGO_AUTOR`, `PK_PESQUISADOR`).
* **Objetos:** `TB_` (tabelas negociais), `RL_` (tabelas de relacionamento N:M), `SP_` (Stored Procedures).
* **Colunas:** `ID_` (PK), `CD_` (Códigos), `DS_` (Descrição), `DT_` (Data).

### Modelo Entidade-Relacionamento (MER)

O modelo conceitual foi elaborado na **Notação Peter Chen**, apresentando um mini-mundo com **7 entidades fortes** e **5 relacionamentos N:M** resolvidos, resultando em **12 tabelas** no Modelo Lógico (DDL).

**- Notação Peter Chen**

[![](https://mermaid.ink/img/pako:eNp1U11vmzAU_SuWnzaJRpgPO-GhkgFnYsoCM7QPHVVlFdZEKxCxZOqG8rDH_q78sdokZilrefI95557rq8vHbxvihJ68KEVmxXIwrzOayA_-i3z7xKWfr2KUhrG_PYI-wqmPIs-xSckUEjAo4zxSGNhL-bxZ5ZpiCnIpym7C2W5EzhXIGdzxtkyiOitNueoOzwDepXFHIRsfwKtjl7TRUR1bHc0WUQBBcr98CztNeN0QZQNeW4XxAuWSVvAvmgQdwnjmbRlYEgkypWzNImX6eHvNVuAJOaKHIYCLi7AB2SA5Ud5upR96n5HhK8V_lhh6-ZHRPCuwtGX6glzIOZH_B2Vqy8_UrHXPv8IjvVkRqXCcx86Vln6cUaE_7_qrDuiJ65VaPA66078Eo9rUTRg07Q9rXavX4GAxmeVj3lvZOQ1NORmrwvobdtdacCqbCuhQtgpfQ63q7Iqc-jJYyHaHznM673UbER90zSVlrXN7mEFve_i8aeMdptCbMtwLeQ_Uw1oW9ZF2QbNrt5CD01JXwR6HXySIXInJkIEO66FbUzQzIC_oTezJth0p7Yzw-bMJu7egH96V3MyRaZjEosQjC1kOfsXefTu_g?type=png)](https://mermaid.live/edit#pako:eNp1U11vmzAU_SuWnzaJRpgPO-GhkgFnYsoCM7QPHVVlFdZEKxCxZOqG8rDH_q78sdokZilrefI95557rq8vHbxvihJ68KEVmxXIwrzOayA_-i3z7xKWfr2KUhrG_PYI-wqmPIs-xSckUEjAo4zxSGNhL-bxZ5ZpiCnIpym7C2W5EzhXIGdzxtkyiOitNueoOzwDepXFHIRsfwKtjl7TRUR1bHc0WUQBBcr98CztNeN0QZQNeW4XxAuWSVvAvmgQdwnjmbRlYEgkypWzNImX6eHvNVuAJOaKHIYCLi7AB2SA5Ud5upR96n5HhK8V_lhh6-ZHRPCuwtGX6glzIOZH_B2Vqy8_UrHXPv8IjvVkRqXCcx86Vln6cUaE_7_qrDuiJ65VaPA66078Eo9rUTRg07Q9rXavX4GAxmeVj3lvZOQ1NORmrwvobdtdacCqbCuhQtgpfQ63q7Iqc-jJYyHaHznM673UbER90zSVlrXN7mEFve_i8aeMdptCbMtwLeQ_Uw1oW9ZF2QbNrt5CD01JXwR6HXySIXInJkIEO66FbUzQzIC_oTezJth0p7Yzw-bMJu7egH96V3MyRaZjEosQjC1kOfsXefTu_g)


**- ER**

[![](https://mermaid.ink/img/pako:eNqVVv9ymkAQfpWb-ztJNWqN_EcAOxeJUH44nY4zzhUuhqmCPdFJa3yRvkGeIy_WBQVOOa3hL2D32_2-3b2FDQ6SkGEFM65HdMrpfBwjuLz7iW24X33iqrrloM3ubXZFcYqIfmC1B2iMScjiNHqKAhomHL3_jaMgGeMKt6Y8eKYcDR9FbN2uuxPjUSUm8rOoxpxGszPRwJsMXY94PtFUa2fflhJUxyNfLAn7veGjxLM8plWZUvaSZhQcw_UfhfchTRnSvYnt35vAq2QmhtP0iW6Rncrs5jBxpUFziGc4RKaiNNkDaXyP2FblBEqHmum7qvXJ-La7EWUWWnTDBYikmI7RNxxjqBFVQkUwyshIaid0UPU9C0p4nNB2rAfDkwkvLCdSFWZ_UG8JGRKNyGkYrgcjecziXnWNiQ4GCY_KdoJJ5VBwEYZzpJokmw3ZfJY2MfDh8PazyVF5Gk0TpK7pLIL5FRtadmZEXDikubvNlr9W0TKfdIeto2XCRUi8mjMeBWhkToaWp9arlwcTRkO6LF5fr6-TDXLMPdNdf5EC-d_fEF2lkDxkRd7qmJ7HBVEKtBGbF8Bjv_M7qn-mjpXlR5LMGI0R2Q8ljBIcGmKrZl3yKdZZz3PST0mEAoh3xPtgpk6jgyRO398kanOPzSVqalPalxwIzTKNotWXyCv3SUaSLmawNwVlpfU8LpuDHAqVoXWJZ3beaZklqD-QHu8HH74TfdhsHhldone_RQpDRnvBeMrigCFRcrFtziLh07paiEqPfD4itEjYH1zeNWE_58MFh0mQIFj_hyxOIkWLandIvU9JmmjEU2W6KmzuoqtShZJNc7BMM5JTxuknYMoPV1ytPjVgNpfCKj2d9FXs_B7J2XKRxEu6ZrNdcfAVnvIoxErKV-wKw26Fvxl4xHlpxjh9ZnPYgxk8pPxnlnELmAWNvyfJvIDxZDV9xsoTnS3habXIDu7-X618y1kcMq4lqzjFSrd9mwfByga_YKXZbtz0PjfarVav04ObXvsK_8bKbbd907zrdlqNTrPb6d41t1f4T562cQOvG3C1Ot3eXbvb6mz_ASLo6Zo?type=png)](https://mermaid.live/edit#pako:eNqVVv9ymkAQfpWb-ztJNWqN_EcAOxeJUH44nY4zzhUuhqmCPdFJa3yRvkGeIy_WBQVOOa3hL2D32_2-3b2FDQ6SkGEFM65HdMrpfBwjuLz7iW24X33iqrrloM3ubXZFcYqIfmC1B2iMScjiNHqKAhomHL3_jaMgGeMKt6Y8eKYcDR9FbN2uuxPjUSUm8rOoxpxGszPRwJsMXY94PtFUa2fflhJUxyNfLAn7veGjxLM8plWZUvaSZhQcw_UfhfchTRnSvYnt35vAq2QmhtP0iW6Rncrs5jBxpUFziGc4RKaiNNkDaXyP2FblBEqHmum7qvXJ-La7EWUWWnTDBYikmI7RNxxjqBFVQkUwyshIaid0UPU9C0p4nNB2rAfDkwkvLCdSFWZ_UG8JGRKNyGkYrgcjecziXnWNiQ4GCY_KdoJJ5VBwEYZzpJokmw3ZfJY2MfDh8PazyVF5Gk0TpK7pLIL5FRtadmZEXDikubvNlr9W0TKfdIeto2XCRUi8mjMeBWhkToaWp9arlwcTRkO6LF5fr6-TDXLMPdNdf5EC-d_fEF2lkDxkRd7qmJ7HBVEKtBGbF8Bjv_M7qn-mjpXlR5LMGI0R2Q8ljBIcGmKrZl3yKdZZz3PST0mEAoh3xPtgpk6jgyRO398kanOPzSVqalPalxwIzTKNotWXyCv3SUaSLmawNwVlpfU8LpuDHAqVoXWJZ3beaZklqD-QHu8HH74TfdhsHhldone_RQpDRnvBeMrigCFRcrFtziLh07paiEqPfD4itEjYH1zeNWE_58MFh0mQIFj_hyxOIkWLandIvU9JmmjEU2W6KmzuoqtShZJNc7BMM5JTxuknYMoPV1ytPjVgNpfCKj2d9FXs_B7J2XKRxEu6ZrNdcfAVnvIoxErKV-wKw26Fvxl4xHlpxjh9ZnPYgxk8pPxnlnELmAWNvyfJvIDxZDV9xsoTnS3habXIDu7-X618y1kcMq4lqzjFSrd9mwfByga_YKXZbtz0PjfarVav04ObXvsK_8bKbbd907zrdlqNTrPb6d41t1f4T562cQOvG3C1Ot3eXbvb6mz_ASLo6Zo)

### 2.3. Modelo Lógico (Esquema Principal)

| Tabela | Tipo | Descrição |
| :--- | :--- | :--- |
| `TB_PESQUISADOR` | Entidade | Autores e Revisores do sistema. |
| `TB_ARTIGO` | Entidade | Artigo científico principal (com metadados). |
| `TB_AVALIACAO` | Entidade | Registra a nota e o comentário de um revisor sobre um artigo (Requisito R3/R4). |
| `TB_CRITERIO` | Entidade | Critérios de Inclusão e Exclusão. |
| `TB_PROJETO` | Entidade | Agrupamento de Revisão Sistemática. |
| `RL_ARTIGO_AUTOR` | Associativa | Liga Artigo a seus autores. |
| `RL_ARTIGO_CRITERIO` | Associativa | Aplicação dos critérios a cada artigo. |

## 3. População e Stored Procedures

O banco de dados foi populado com **5.000 registros** nas tabelas principais (`TB_PESQUISADOR` e `TB_ARTIGO`) para simular um ambiente de Big Data em Revisão Sistemática.

### Bulk Insertion

Para garantir o volume de dados e a integridade referencial, utilizamos **Stored Procedures (SP)** em `PL/pgSQL` (ou linguagem de SGBD equivalente):

* **`SP_POPULAR_PESQUISADOR(N)`:** Insere N pesquisadores com e-mails e instituições simulados.
* **`SP_POPULAR_ARTIGO(N)`:** Insere N artigos e, em seguida, associa aleatoriamente 1 ou 2 autores a cada artigo (`RL_ARTIGO_AUTOR`).

## 4. Consultas e Otimização (Plano de Indexação)

O sistema suporta **30 consultas analíticas** para atender aos requisitos de estatística e relatórios (R5).

* **10 Consultas Intermediárias:** Uso de `JOIN` em 3+ tabelas e 2+ funções de agregação/janela.
* **20 Consultas Avançadas:** Uso de `JOIN` em 3+ tabelas e 3+ funções, incluindo `SUB-CONSULTAS` e `WINDOW FUNCTIONS` complexas.

### Otimização de Desempenho

Para otimizar o tempo de execução dessas 30 consultas, foi desenvolvido um **Plano de Indexação**. Os índices foram criados (com prefixo `IDX_`) para as colunas mais utilizadas em cláusulas `WHERE` e `JOIN`.

**(Próxima etapa! Aqui você listará os índices criados e o speedup obtido.)**

## 5. Governança e Administração (DCL, Auditoria)

O projeto aplica as políticas de governança fornecidas:

* **Política de Preservação de Privacidade (PPP):** Implementação de regras de **Controle de Acesso (DCL)**, definindo *roles* de `DBA`, `SISTEMA` e `ANALISE` com permissões restritas (ex: `SELECT` apenas para `ANALISE` em views).
* **Auditoria:** Configuração de triggers (`TG_`) para rastrear modificações (INSERT/UPDATE/DELETE) em tabelas sensíveis como `TB_ARTIGO` (Requisito de Auditoria da PPP).
* **Backup e Recuperação (PBR):** O ambiente está configurado para seguir a `# [PBR1] Política de backup e recup.txt` com backups Full semanais.

## 6. Arquivos e Execução

| Arquivo | Conteúdo |
| :--- | :--- |
| `01_DDL_ESQUEMA.sql` | Criação de todas as tabelas (`TB_` e `RL_`), sequences e constraints. |
| `02_DML_POPULACAO.sql` | Comandos `INSERT INTO` manuais, `CREATE FUNCTION` (Stored Procedures) e chamadas para inserção dos 5.000+ registros. |
| `03_DML_CONSULTAS.sql` | As 30 consultas SQL (I.1 a I.10 e A.1 a A.20). |
| `04_DML_INDEXES.sql` | Criação dos índices (`CREATE INDEX IDX_...`) e, opcionalmente, o script de medição de desempenho. |
| `RELATORIO_FINAL.pdf` | O relatório no formato SBC. |

