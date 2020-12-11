DROP VIEW TASY.HOBRASIL_INDICADOR_OS_TI;

CREATE 
OR REPLACE VIEW TASY.HOBRASIL_INDICADOR_OS_TI AS 
SELECT
    X.NR_SEQUENCIA,
    X.NR_SEQ_WHEB,
    MAX(X.DS_DANO_BREVE) DS_DANO_BREVE,
    CASE
        WHEN
            NVL(ROUND(X.DT_FIM_REAL - NVL(X.DT_INICIO_REAL, X.DT_FIM_REAL)), 0) < 5 
        THEN
            '1: Até 5 dias' 
        WHEN
            NVL(ROUND(X.DT_FIM_REAL - NVL(X.DT_INICIO_REAL, X.DT_FIM_REAL)), 0) BETWEEN 6 AND 15 
        THEN
            '2: Até 15 dias' 
        WHEN
            NVL(ROUND(X.DT_FIM_REAL - NVL(X.DT_INICIO_REAL, X.DT_FIM_REAL)), 0) BETWEEN 16 AND 25 
        THEN
            '3: Até 25 dias' 
        WHEN
            NVL(ROUND(X.DT_FIM_REAL - NVL(X.DT_INICIO_REAL, X.DT_FIM_REAL)), 0) BETWEEN 26 AND 45 
        THEN
            '4: Até 45 dias' 
        WHEN
            NVL(ROUND(X.DT_FIM_REAL - NVL(X.DT_INICIO_REAL, X.DT_FIM_REAL)), 0) > 25 
        THEN
            '5: Acima de 45 dias' 
        ELSE
            '6: Não finalizado' 
    END
    DS_DIA_EXEC, 
    CASE
        WHEN
            NVL(ROUND(NVL(X.DT_FIM_REAL, SYSDATE) - NVL(MAX(X.DT_FIM_PREVISTO), X.DT_FIM_REAL)), 0) < 5 
        THEN
            '1: Até 5 dias' 
        WHEN
            NVL(ROUND(NVL(X.DT_FIM_REAL, SYSDATE) - NVL(MAX(X.DT_FIM_PREVISTO), X.DT_FIM_REAL)), 0) BETWEEN 6 AND 15 
        THEN
            '2: Até 15 dias' 
        WHEN
            NVL(ROUND(NVL(X.DT_FIM_REAL, SYSDATE) - NVL(MAX(X.DT_FIM_PREVISTO), X.DT_FIM_REAL)), 0) BETWEEN 16 AND 25 
        THEN
            '3: Até 25 dias' 
        WHEN
            NVL(ROUND(NVL(X.DT_FIM_REAL, SYSDATE) - NVL(MAX(X.DT_FIM_PREVISTO), X.DT_FIM_REAL)), 0) BETWEEN 26 AND 45 
        THEN
            '4: Até 45 dias' 
        WHEN
            NVL(ROUND(NVL(X.DT_FIM_REAL, SYSDATE) - NVL(MAX(X.DT_FIM_PREVISTO), X.DT_FIM_REAL)), 0) > 45 
        THEN
            '5: Acima de 45 dias' 
        ELSE
            '6: Não finalizado' 
    END
    DS_DIA_ATRASO, 	--nvl(round(x.dt_fim_real - nvl(max(x.dt_fim_previsto), x.dt_fim_real)),0) qt_dia_atraso,
    --obter_min_entre_datas(dt_ordem_servico, max(x.dt_inicio_real), 1)/60 qt_min_prim_atend,
    --OBTER_HORA_ENTRE_DATAS(dt_ordem_servico, max(x.dt_inicio_real)) qt_horas_prim_atend,
(
    SELECT
        SUM(MAN_OBTER_TEMPO_ESTAGIO(W.NR_SEQUENCIA, X.NR_SEQUENCIA, 'MC')) 
    FROM
        MAN_ORDEM_SERV_ESTAGIO W 
    WHERE
        W.NR_SEQ_ORDEM = X.NR_SEQUENCIA 
        AND W.NR_SEQ_ESTAGIO = '82') QT_MIN_PRIM_ATEND,
        (
(
            SELECT
                SUM(MAN_OBTER_TEMPO_ESTAGIO(W.NR_SEQUENCIA, X.NR_SEQUENCIA, 'MC')) 
            FROM
                MAN_ORDEM_SERV_ESTAGIO W 
            WHERE
                W.NR_SEQ_ORDEM = X.NR_SEQUENCIA 
                AND W.NR_SEQ_ESTAGIO = '82') / 60
        )
        QT_HORAS_PRIM_ATEND,
        (
            SELECT
                SUM(W.QT_MINUTO) 
            FROM
                MAN_ORDEM_SERV_ATIV W 
            WHERE
                W.NR_SEQ_ORDEM_SERV = X.NR_SEQUENCIA
        )
        QT_MIN_ATIV_OS,
        (
            SELECT
                DIVIDIR(SUM(W.QT_MINUTO), 60) 
            FROM
                MAN_ORDEM_SERV_ATIV W 
            WHERE
                W.NR_SEQ_ORDEM_SERV = X.NR_SEQUENCIA
        )
        QT_HORAS_ATIV_OS,
        OBTER_DIA_SEMANA(NVL(X.DT_FIM_REAL, SYSDATE)) DS_DIA_SEMANA,
        MAX(X.IE_PRIORIDADE) IE_PRIORIDADE,
        SUBSTR(OBTER_VALOR_DOMINIO(1046, MAX(X.IE_PRIORIDADE)), 1, 200) DS_PRIORIDADE,
        MAX(X.IE_PARADO) IE_PARADO,
        DECODE(MAX(X.IE_PARADO), 'S', 'Sim', 'N', 'Não', 'P', 'Parcialmente') DS_PARADO,
        MAX(X.NR_SEQ_LOCALIZACAO) NR_SEQ_LOCALIZACAO,
        MAX(L.DS_LOCALIZACAO) DS_LOCALIZACAO,
        SUBSTR(OBTER_VALOR_DOMINIO(1149, X.IE_CLASSIFICACAO), 1, 20) DS_CLASSIFICACAO,
        MAX(X.NR_SEQ_CLASSIF) NR_SEQ_CLASSIF,
        OBTER_DESC_CLASSIFICACAO(MAX(X.NR_SEQ_CLASSIF)) DS_SUB_CLASSIFICACAO,
        X.DT_ORDEM_SERVICO,
        X.DT_ORDEM_SERVICO DT_PARAMETRO,
        X.DT_INICIO_REAL,
        X.DT_FIM_REAL,
        NVL(TRUNC(X.DT_FIM_REAL, 'MM'), TRUNC(X.DT_ORDEM_SERVICO, 'MM')) DT_VISAO_PERIODO,
        MAX(X.CD_PESSOA_SOLICITANTE) CD_PESSOA_SOLICITANTE,
        MAX(F.CD_PESSOA_FISICA) CD_PESSOA_FISICA,
        SUBSTR(NVL(F.DS_APELIDO, F.NM_PESSOA_FISICA), 1, 60) NM_SOLICITANTE,
        MAX(X.NR_SEQ_EQUIPAMENTO) NR_SEQ_EQUIPAMENTO,
        SUBSTR(MAN_OBTER_DESC_EQUIP_OS_PAR(X.NR_SEQ_EQUIPAMENTO), 1, 255) DS_EQUIPAMENTO,
        MAX(S.CD_SETOR_ATENDIMENTO) CD_SETOR_ATENDIMENTO,
        MAX(NVL(OBTER_CENTRO_CUSTO_SETOR(S.CD_SETOR_ATENDIMENTO, 'C'), '***Não Informado')) CD_CENTRO_CUSTO,
        MAX(NVL(OBTER_CENTRO_CUSTO_SETOR(S.CD_SETOR_ATENDIMENTO, 'DS'), '***Não Informado')) DS_CENTRO_CUSTO,
        MAX(L.CD_CENTRO_CUSTO) CD_CENTRO_CUSTO_LOCALIZ,
        MAX(OBTER_DESC_CENTRO_CUSTO(L.CD_CENTRO_CUSTO)) DS_CENTRO_CUSTO_LOCALIZ,
        SUBSTR(NVL(MAN_OBTER_DADOS_SOLICITANTE(MAX(X.CD_PESSOA_SOLICITANTE), 'CC'), '***Não Informado'), 1, 255) CD_CENTRO_CUS_SOLIC,
        SUBSTR(NVL(MAN_OBTER_DADOS_SOLICITANTE(MAX(X.CD_PESSOA_SOLICITANTE), 'DCC'), '***Não Informado'), 1, 255) DS_CENTRO_CUS_SOLIC,
        S.DS_SETOR_ATENDIMENTO,
        MAX(L.CD_ESTABELECIMENTO) CD_ESTABELECIMENTO,
        INITCAP(SUBSTR(OBTER_NOME_ESTABELECIMENTO(L.CD_ESTABELECIMENTO), 1, 255)) DS_ESTAB_LOCALIZ,
        X.NR_GRUPO_TRABALHO,
        T.DS_GRUPO_TRABALHO,
        X.IE_STATUS_ORDEM,
        DECODE(X.IE_STATUS_ORDEM, 1, 'Aberta', 2, 'Processo', 'Encerrado') DS_STATUS_ORDEM,
        P.NR_SEQUENCIA CD_ESTAGIO,
        P.DS_ESTAGIO,
        NVL(U.DS_USUARIO, '***Não Informado') DS_USUARIO_EXEC,
        NVL(I.DS_COMPLEXIDADE, '***Não Informado') DS_COMPLEXIDADE,
        X.IE_CLASSIFICACAO,
        SUBSTR(OBTER_VALOR_DOMINIO(1197, X.IE_GRAU_SATISFACAO), 1, 100) DS_GRAU_SATISFACAO,
        MAX(X.CD_FUNCAO) CD_FUNCAO,
        F.DS_FUNCAO,
        MAX(X.NR_GRUPO_PLANEJ) NR_GRUPO_PLANEJ,
        MAX(G.DS_GRUPO_PLANEJ) DS_GRUPO_PLANEJAMENTO,
        COUNT(*) QT_TOTAL,
        --case when trunc(x.dt_ordem_servico,'MM') = nvl(trunc(x.dt_fim_real,'MM'),trunc(x.dt_ordem_servico,'MM')) and x.ie_status_ordem <> 3 then 1 else 0 end Qtd_pendente,
        CASE
            WHEN
                X.IE_STATUS_ORDEM <> 3 
            THEN
                1 
            ELSE
                0 
        END
        QTD_PENDENTE, 
        CASE
            WHEN
                TRUNC(X.DT_ORDEM_SERVICO, 'MM') = NVL(TRUNC(X.DT_FIM_REAL, 'MM'), TRUNC(X.DT_ORDEM_SERVICO, 'MM')) 
                AND X.IE_STATUS_ORDEM = 3 
            THEN
                1 
            ELSE
                0 
        END
        QT_ENCERRADA, 
        CASE
            WHEN
                TRUNC(X.DT_ORDEM_SERVICO, 'MM') = TRUNC(X.DT_ORDEM_SERVICO, 'MM') 
                AND X.IE_STATUS_ORDEM = 3 
            THEN
                1 
            ELSE
                0 
        END
        QT_ENCERRADA_COMP, 
        CASE
            WHEN
                TRUNC(X.DT_ORDEM_SERVICO, 'MM') <> TRUNC(X.DT_FIM_REAL, 'MM') 
            THEN
                1 
            ELSE
                0 
        END
        IE_COMP_ANTERIOR, 
        CASE
            WHEN
                TRUNC(X.DT_ORDEM_SERVICO, 'MM') <> TRUNC(X.DT_FIM_REAL, 'MM') 
                AND X.IE_STATUS_ORDEM <> 3 
            THEN
                1 
            ELSE
                0 
        END
        IE_COMP_ANTERIOR_PEND, 
        CASE
            WHEN
                TRUNC(X.DT_ORDEM_SERVICO, 'MM') <> TRUNC(X.DT_FIM_REAL, 'MM') 
                AND X.IE_STATUS_ORDEM = 3 
            THEN
                1 
            ELSE
                0 
        END
        IE_COMP_ANTERIOR_ENC, 
        (
            CASE
                WHEN
                    TRUNC(X.DT_ORDEM_SERVICO, 'MM') = NVL(TRUNC(X.DT_FIM_REAL, 'MM'), TRUNC(X.DT_ORDEM_SERVICO, 'MM')) 
                    AND X.IE_STATUS_ORDEM = 3 
                THEN
                    1 
                ELSE
                    0 
            END
            + 
            CASE
                WHEN
                    TRUNC(X.DT_ORDEM_SERVICO, 'MM') < TRUNC(X.DT_FIM_REAL, 'MM') 
                    AND X.IE_STATUS_ORDEM = 3 
                THEN
                    1 
                ELSE
                    0 
            END
        )
        QTD_TOTAL_ENCERRADAS, 
        CASE
            WHEN
                UPPER(T.DS_GRUPO_TRABALHO) LIKE UPPER('TI%INFRA%') 
                AND X.NR_GRUPO_TRABALHO <> '864' 
            THEN
                'INFRA' 
            WHEN
                X.NR_GRUPO_TRABALHO = '864' 
            THEN
                'SOBREAVISO' 
            ELSE
                'APLICAÇÕES' 
        END
        DS_CATEGORIA_GRUPO, NULL NENHUM 
    FROM
        FUNCAO F, USUARIO U, MAN_CAUSA_DANO K, MAN_TIPO_SOLUCAO Y, SETOR_ATENDIMENTO S, GRUPO_SUPORTE O, GPI_PROJETO W, GPI_CRON_ETAPA V, PESSOA_FISICA F, GRUPO_DESENVOLVIMENTO D, MAN_COMPLEXIDADE I, MAN_CLASSIFICACAO C, MAN_GRUPO_TRABALHO T, MAN_GRUPO_PLANEJAMENTO G, MAN_CATALOGO_SERVICO Z, MAN_ESTAGIO_PROCESSO P, MAN_EQUIPAMENTO E, MAN_LOCALIZACAO L, MAN_ORDEM_SERVICO X, PROJETO_TASY PT 
    WHERE
        X.CD_PESSOA_SOLICITANTE = F.CD_PESSOA_FISICA 
        AND S.CD_SETOR_ATENDIMENTO = L.CD_SETOR 
        AND X.NR_SEQ_EQUIPAMENTO = E.NR_SEQUENCIA 
        AND X.NR_SEQ_LOCALIZACAO = L.NR_SEQUENCIA 
        AND X.CD_FUNCAO = F.CD_FUNCAO( + ) 
        AND X.NR_SEQ_PROJ_GPI = W.NR_SEQUENCIA( + ) 
        AND X.NR_SEQ_ETAPA_GPI = V.NR_SEQUENCIA( + ) 
        AND X.NM_USUARIO_EXEC = U.NM_USUARIO( + ) 
        AND X.NR_SEQ_ESTAGIO = P.NR_SEQUENCIA( + ) 
        AND X.NR_GRUPO_TRABALHO = T.NR_SEQUENCIA( + ) 
        AND X.NR_GRUPO_PLANEJ = G.NR_SEQUENCIA( + ) 
        AND X.NR_SEQ_GRUPO_SUP = O.NR_SEQUENCIA( + ) 
        AND X.NR_SEQ_GRUPO_DES = D.NR_SEQUENCIA( + ) 
        AND X.NR_SEQ_CLASSIF = C.NR_SEQUENCIA( + ) 
        AND X.NR_SEQ_COMPLEX = I.NR_SEQUENCIA( + ) 
        AND X.NR_SEQ_CAUSA_DANO = K.NR_SEQUENCIA( + ) 
        AND X.NR_SEQ_TIPO_SOLUCAO = Y.NR_SEQUENCIA( + ) 
        AND X.NR_SEQ_CS = Z.NR_SEQUENCIA( + ) 
        AND X.NR_SEQ_PROJETO = PT.NR_SEQUENCIA( + ) 		--AND UPPER(t.ds_grupo_trabalho) LIKE UPPER('TI%')
        --and nvl(trunc(x.dt_fim_real,'MM'),trunc(x.dt_ordem_servico,'MM')) = '01/07/2015'
        --and trunc(x.DT_ORDEM_SERVICO,'MM') = '01/07/2015'
        --AND X.NR_GRUPO_PLANEJ = 1625 		-- Grupo de planejamento SUPORTE TI
        --and x.ie_status_ordem = 3
    GROUP BY
        X.NR_SEQUENCIA, X.NR_SEQ_WHEB, SUBSTR(OBTER_VALOR_DOMINIO(1149, X.IE_CLASSIFICACAO), 1, 20), X.DT_ORDEM_SERVICO, X.DT_INICIO_REAL, X.DT_FIM_REAL, SUBSTR(NVL(F.DS_APELIDO, F.NM_PESSOA_FISICA), 1, 60), SUBSTR(MAN_OBTER_DESC_EQUIP_OS_PAR(X.NR_SEQ_EQUIPAMENTO), 1, 255), S.DS_SETOR_ATENDIMENTO, SUBSTR(OBTER_NOME_ESTABELECIMENTO(L.CD_ESTABELECIMENTO), 1, 255) , T.DS_GRUPO_TRABALHO, DECODE(X.IE_STATUS_ORDEM, 1, 'Aberta', 2, 'Processo', 'Encerrado') , P.DS_ESTAGIO, U.DS_USUARIO, I.DS_COMPLEXIDADE, X.IE_CLASSIFICACAO, SUBSTR(OBTER_VALOR_DOMINIO(1197, X.IE_GRAU_SATISFACAO), 1, 100), F.DS_FUNCAO, X.NR_GRUPO_TRABALHO, IE_STATUS_ORDEM, P.NR_SEQUENCIA;

SELECT * FROM TASY.HOBRASIL_INDICADOR_OS_TI;