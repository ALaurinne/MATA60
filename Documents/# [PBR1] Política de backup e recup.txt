# [PBR1] Política de backup e recuperação FULL

# **Seção 1: Estratégias de Backup**

- **Tipo de Backup**: Full (completo).
- **Artefatos**: Bancos de dados, catálogo do banco de dados e configurações do SGBD.
- **Temporalidade**: Semanal.
- **Armazenamento:** Local e remoto (Drive, github, dropbox, etc.)
- **Responsabilidades**: Administrador de backup utilizando o usuário `pg_dbbackup`.

# **Seção 2: Procedimentos de Teste**

- **Testes de Integridade**: Diários, verificando logs de backup em busca de erros.
- **Testes de Restauração**: Mensais, em ambientes isolados de produção, com relatórios enviados à CGTI.
- **Validação**: Confirmação de RTO (Recovery Time Objective) e RPO (Recovery Point Objective) conforme pactuado.

# **Seção 3: Estratégias de Recuperação**

- **Armazenamento Local**: Restauração prioritária em até 4 horas para sistemas críticos.
- **Armazenamento Online**: Restauração em até 24 horas, com dados criptografados e acesso restrito a autorizados.
- **Documentação**: Todas as restaurações devem ser registradas, incluindo tempo gasto e sucesso da operação.

<aside>
💡

Todos os arquivos gerados pelas rotinas de backup devem ser armazenados ou recuperados localmente ou

</aside>