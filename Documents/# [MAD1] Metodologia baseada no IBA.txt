# [MAD1] Metodologia baseada no IBAMA

# Seção 1: Regras Gerais para o Padrão de Nomenclatura

## **Formação dos Nomes:**

- Tamanho máximo: 30 caracteres
- Formato: Prefixo_NomeObjeto (separado por underscore)
- Palavras no singular, em português, sem acentos ou caracteres especiais
- Letras maiúsculas para todas as palavras

### **Prefixos/Sufixos:**

- Tabelas:
    - TB_ para tabelas de sistema
    - RL_ para tabelas associativas
    - TH_ para tabelas de histórico
    - TL_ para tabelas de log
    - TA_ para tabelas de auditoria
- Constraints:
    - PK_ para chave primária
    - FK_ para chave estrangeira
    - UK_ para chave única
    - CK_ para check constraints
    - DF_ para valores default
    - NN_ para NOT NULL (quando nomeada)
    - IDX_ para índices
    - CC_ para check constraints
- Outros objetos:
    - FC_ para funções
    - SP_ para stored procedures
    - VW_ para views
    - VM_ para views materializadas
    - SQ_ para sequences
    - TG_ para triggers (com prefixos A/B para after/before e I/U/D para eventos)
- Colunas:
    - ID_ para identificadores com sequence
    - CD_ para códigos
    - DT_ para datas
    - DH_ para data+hora
    - ST_ para status
    - IS_ para flags booleanas (IS_ACTIVE)
    - HAS_ para indicadores de existência
    - TP_ para tipos
    - VL_ para valores monetários
    - DS_ para descrições
    - TS_ para timestamps

# Seção 2: Regras para Criação de Objetos

## **Chaves Primárias:**

- Obrigatórias para tabelas negociais
- Preferência por tipos numéricos e de pequena extensão
- Devem ser estáveis (não mudar frequentemente)
- Documentar forma de alimentação (sequence, etc.)

## **Chaves Estrangeiras:**

- Devem referenciar todas as colunas da PK da tabela referenciada
- Colunas devem ser NOT NULL quando possível
- Para FK múltiplas, incluir nome representativo (FK_TabelaPai_TabelaFilha_Nome)

## **Índices:**

- Criar para colunas frequentemente usadas em WHERE, ORDER BY ou JOINs
- Documentar na ferramenta CASE
- Evitar em colunas com baixa seletividade ou muitos NULLs

## **Triggers:**

- Usar principalmente para auditoria, histórico e integridade
- Nomenclatura: TG_[B/A]_[I/U/D]_NomeTabela
- Triggers de log devem ser AFTER FOR EACH ROW
- Documentar finalidade no dicionário de dados

## **Views:**

- Usar para simplificar consultas complexas ou restringir acesso
- Evitar views aninhadas profundamente
- Associar adequadamente a view a um ou mais requisitos do Sistema de Informação

## **Auditoria:**

- Tabelas de auditoria devem conter todas colunas da tabela origem mais:
    - TP_OPERACAO (I/U/D)
    - DT_OPERACAO
    - NM_USUARIO_BD
    - NM_USUARIO_APLICACAO
    - NM_TERMINAL
- Apenas equipes de AD e DBA devem ter acesso de leitura

<aside>
💡

Para garantir esta auditoria, deve criar `*funções*` ou `*stored procedures*` adequadas para armazenar estas informações, substituindo clausulas SQL nativas. 

</aside>