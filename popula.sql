INSERT INTO TB_PESQUISADOR (DS_NOME, DS_EMAIL, DS_CPF)
SELECT
    'Pesquisador ' || LPAD(g.seq_num::text, 2, '0') || ' - ' || 
    CASE WHEN g.seq_num <= 10 THEN 'Lider' ELSE 'Junior' END,
    'pesquisador' || g.seq_num || '@uni.br',
    LPAD(g.seq_num::text, 11, '0')
FROM generate_series(1, 60) AS g(seq_num);

INSERT INTO TB_REVISAO (DS_TITULO, DS_DESCRICAO, DT_INICIO, DT_CONCLUSAO)
SELECT
    'Revisão Sistemática - ' || 
    CASE WHEN g.seq_num <= 5 THEN 'Alto Impacto ' ELSE 'Foco Temático ' END || LPAD(g.seq_num::text, 2, '0'),
    'Descrição detalhada da metodologia para o tema ' || g.seq_num || '.',
    (CURRENT_DATE - (g.seq_num * 60 * INTERVAL '1 day'))::DATE,
    CASE WHEN g.seq_num % 4 != 0 
         THEN (CURRENT_DATE - (g.seq_num * 15 * INTERVAL '1 day'))::DATE 
         ELSE NULL 
    END 
FROM generate_series(1, 15) AS g(seq_num);

INSERT INTO TB_REPOSITORIO (DS_NOME, DS_URL, DT_CRIACAO)
VALUES 
('Repositório IA e ML', 'https://repo.ia.com/acervo', '2018-05-15'),
('Acervo de Ciências Humanas', 'https://repo.humanas.org/pesquisas', '2015-11-20'),
('Base de Dados de Engenharia', 'https://repo.eng.br/docs', '2020-01-01'),
('Biblioteca de Sustentabilidade', 'https://repo.sustenta.net/docs', '2022-08-10'),
('Revista de Economia e Finanças', 'https://repo.economia.com/artigos', '2019-03-25'),
('Journal de Medicina e Saúde', 'https://repo.saude.org/docs', '2021-10-10');

WITH REPO_INFO AS (
    SELECT MIN(ID_REPOSITORIO) AS min_id, COUNT(ID_REPOSITORIO) AS total_repos FROM TB_REPOSITORIO
)
INSERT INTO TB_ARTIGO (DS_TITULO, DS_RESUMO, CD_ANO_PUBLICACAO, ID_REPOSITORIO)
SELECT
    'Artigo Científico Nº ' || LPAD(g.seq_num::text, 4, '0') || ' sobre ' ||
    CASE (g.seq_num % 6)
        WHEN 0 THEN 'Inteligência Artificial e Ética'
        WHEN 1 THEN 'Impacto Social da Globalização'
        WHEN 2 THEN 'Novo Concreto Auto-Reparável'
        WHEN 3 THEN 'Economia Circular'
        WHEN 4 THEN 'Análise de Risco Financeiro'
        ELSE 'Epidemiologia Moderna'
    END,
    'Resumo do estudo ' || g.seq_num || ', focado na análise de dados e tendências.',
    2005 + ((g.seq_num * 17) % 21), 
    (g.seq_num % (SELECT total_repos FROM REPO_INFO)) + (SELECT min_id FROM REPO_INFO)
FROM
    generate_series(1, 5500) AS g(seq_num);

WITH REVISAO_INFO AS (
    SELECT MIN(ID_REVISAO) AS min_id, COUNT(ID_REVISAO) AS total_revs FROM TB_REVISAO
)
INSERT INTO TB_CRITERIO (DS_DESCRICAO, TP_CRITERIO, ID_REVISAO)
SELECT
    'Critério ' || (g.seq_num % 5 + 1) || ' para Revisão ' || ((g.seq_num - 1) / 5 + 1) || ' - ' ||
    CASE WHEN g.seq_num % 2 = 0 THEN 'Metodologia Quantitativa' ELSE 'Foco Qualitativo' END,
    CASE WHEN g.seq_num % 2 = 0 THEN 'INCLUSAO' ELSE 'EXCLUSAO' END,
    ((g.seq_num - 1) / 5) + (SELECT min_id FROM REVISAO_INFO)
FROM generate_series(1, 75) AS g(seq_num);

WITH PESQ_INFO AS (
    SELECT MIN(ID_PESQUISADOR) AS min_p_id FROM TB_PESQUISADOR
),
REV_INFO AS (
    SELECT MIN(ID_REVISAO) AS min_r_id, COUNT(ID_REVISAO) AS total_revs FROM TB_REVISAO
)
INSERT INTO RL_PESQUISADOR_REVISAO (ID_PESQUISADOR, ID_REVISAO)
SELECT 
    (g.seq_num % 60) + (SELECT min_p_id FROM PESQ_INFO), 
    ((g.seq_num - 1) / 10) + (SELECT min_r_id FROM REV_INFO)
FROM generate_series(1, 150) AS g(seq_num)
ON CONFLICT (ID_PESQUISADOR, ID_REVISAO) DO NOTHING;

WITH ARTIGO_INFO AS (
    SELECT MIN(ID_ARTIGO) AS min_a_id, COUNT(ID_ARTIGO) AS total_artigos FROM TB_ARTIGO
)
INSERT INTO TB_ESTATISTICA (DS_METRICA, VL_VALOR, ID_ARTIGO)
SELECT
    CASE ((g.seq_num - 1) % 3)
        WHEN 0 THEN 'Citações'
        WHEN 1 THEN 'Fator de Impacto'
        ELSE 'Visualizações'
    END,
    CASE WHEN (g.seq_num % 50) = 0 THEN (RANDOM() * 5000)::DECIMAL(18, 4) ELSE (RANDOM() * 1000)::DECIMAL(18, 4) END,
    ((g.seq_num - 1) / 3) + (SELECT min_a_id FROM ARTIGO_INFO)
FROM generate_series(1, 5500 * 3) AS g(seq_num);

WITH PESQ_INFO AS (
    SELECT MIN(ID_PESQUISADOR) AS min_p_id, COUNT(ID_PESQUISADOR) AS total_pesquisadores FROM TB_PESQUISADOR
),
REV_INFO AS (
    SELECT MIN(ID_REVISAO) AS min_r_id, COUNT(ID_REVISAO) AS total_revs FROM TB_REVISAO
),
ARTIGO_INFO AS (
    SELECT MIN(ID_ARTIGO) AS min_a_id FROM TB_ARTIGO
)
INSERT INTO TB_AVALIACAO (DS_PARECER, ST_AVALIACAO, DH_AVALIACAO, ID_PESQUISADOR_AVALIADOR_1, ID_PESQUISADOR_AVALIADOR_2, ID_REVISAO, ID_ARTIGO)
SELECT
    'Parecer de avaliação inicial para Artigo ' || g.seq_num,
    CASE (g.seq_num % 4)
        WHEN 0 THEN 'APROVADO'
        WHEN 1 THEN 'REJEITADO'
        WHEN 2 THEN 'PENDENTE'
        ELSE 'EM_REVISAO'
    END,
    CURRENT_TIMESTAMP - (RANDOM() * 100 * INTERVAL '1 day'),
    (g.seq_num % ((SELECT total_pesquisadores FROM PESQ_INFO) - 2)) + (SELECT min_p_id FROM PESQ_INFO),
    ((g.seq_num + 1) % ((SELECT total_pesquisadores FROM PESQ_INFO) - 2)) + (SELECT min_p_id FROM PESQ_INFO),
    (g.seq_num % (SELECT total_revs FROM REV_INFO)) + (SELECT min_r_id FROM REV_INFO),
    g.seq_num + (SELECT min_a_id FROM ARTIGO_INFO) - 1
FROM generate_series(1, 5000) AS g(seq_num);

WITH PESQ_INFO AS (
    SELECT MIN(ID_PESQUISADOR) AS min_p_id, COUNT(ID_PESQUISADOR) AS total_pesquisadores FROM TB_PESQUISADOR
),
REV_INFO AS (
    SELECT MIN(ID_REVISAO) AS min_r_id, COUNT(ID_REVISAO) AS total_revs FROM TB_REVISAO
),
ARTIGO_INFO AS (
    SELECT MIN(ID_ARTIGO) AS min_a_id FROM TB_ARTIGO
)
INSERT INTO TB_AVALIACAO (DS_PARECER, ST_AVALIACAO, DH_AVALIACAO, ID_PESQUISADOR_AVALIADOR_1, ID_PESQUISADOR_AVALIADOR_2, ID_REVISAO, ID_ARTIGO)
SELECT
    'Parecer de RE-AVALIAÇÃO do Artigo ' || g.seq_num,
    CASE (g.seq_num % 2)
        WHEN 0 THEN 'APROVADO'
        ELSE 'REJEITADO'
    END,
    CURRENT_TIMESTAMP - (RANDOM() * 10 * INTERVAL '1 day'),
    (g.seq_num % ((SELECT total_pesquisadores FROM PESQ_INFO) - 1)) + (SELECT min_p_id FROM PESQ_INFO),
    ((g.seq_num + 2) % ((SELECT total_pesquisadores FROM PESQ_INFO) - 1)) + (SELECT min_p_id FROM PESQ_INFO),
    (g.seq_num % (SELECT total_revs FROM REV_INFO)) + (SELECT min_r_id FROM REV_INFO),
    g.seq_num + (SELECT min_a_id FROM ARTIGO_INFO) - 1
FROM generate_series(1, 150) AS g(seq_num);

WITH CRIT_INFO AS (
    SELECT MIN(ID_CRITERIO) AS min_c_id, COUNT(ID_CRITERIO) AS total_criterios FROM TB_CRITERIO
),
ARTIGO_INFO AS (
    SELECT MIN(ID_ARTIGO) AS min_a_id, COUNT(ID_ARTIGO) AS total_artigos FROM TB_ARTIGO
)
INSERT INTO RL_CRITERIO_ARTIGO (ID_CRITERIO, ID_ARTIGO)
SELECT
    ((g.seq_num - 1) % (SELECT total_criterios FROM CRIT_INFO)) + (SELECT min_c_id FROM CRIT_INFO),
    g.seq_num + (SELECT min_a_id FROM ARTIGO_INFO) - 1
FROM generate_series(1, 5500) AS g(seq_num)
UNION ALL
SELECT
    ((g.seq_num) % (SELECT total_criterios FROM CRIT_INFO)) + (SELECT min_c_id FROM CRIT_INFO),
    g.seq_num + (SELECT min_a_id FROM ARTIGO_INFO) - 1
FROM generate_series(1, 5500) AS g(seq_num)
ON CONFLICT DO NOTHING;
