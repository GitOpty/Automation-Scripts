--Alteração de conta contábil do compromisso

SELECT CPG_CCT_COD_PASSIVO,*
FROM CPG
WHERE (CPG.CPG_NUM = 3809) 
    AND (CPG_SERIE = 119)


UPDATE CPG
SET CPG_CCT_COD_PASSIVO = 20050
WHERE (CPG.CPG_NUM = 3809) 
    AND (CPG_SERIE = 119)

-------------------------------------------------------------------------
--Alteração da conta contábil de resultado

SELECT MCC_CCT_COD, *
FROM MCC
WHERE  ((MCC.MCC_CPG_SERIE = 1119)
        AND (MCC.MCC_CPG_NUM = 3867)
        AND (MCC.MCC_TIPO = 'P')
        AND (((MCC.MCC_IND_CPG_GERACAO IS NULL OR (MCC.MCC_IND_CPG_GERACAO = 'N'))
        AND (MCC.MCC_CRE = 0)) OR (MCC.MCC_IND_CPG_GERACAO = 'S')))

UPDATE MCC 
SET MCC_CCT_COD = 60610
WHERE  ((MCC.MCC_CPG_SERIE = 1119)
        AND (MCC.MCC_CPG_NUM = 3867)
        AND (MCC.MCC_TIPO = 'P')
        AND (((MCC.MCC_IND_CPG_GERACAO IS NULL OR (MCC.MCC_IND_CPG_GERACAO = 'N'))
        AND (MCC.MCC_CRE = 0)) OR (MCC.MCC_IND_CPG_GERACAO = 'S')))

-------------------------------------------------------------------------
--Alteração do centro de custo

SELECT MCC_STR_COD, *
FROM MCC
WHERE  ((MCC.MCC_CPG_SERIE = 119)
        AND (MCC.MCC_CPG_NUM = 3806)
        AND (MCC.MCC_TIPO = 'P')
        AND (((MCC.MCC_IND_CPG_GERACAO IS NULL OR (MCC.MCC_IND_CPG_GERACAO = 'N'))
        AND (MCC.MCC_CRE = 0)) OR (MCC.MCC_IND_CPG_GERACAO = 'S')))

UPDATE MCC 
SET MCC_STR_COD = 'ADM'
WHERE  ((MCC.MCC_CPG_SERIE = 119)
        AND (MCC.MCC_CPG_NUM = 3806)
        AND (MCC.MCC_TIPO = 'P')
        AND (((MCC.MCC_IND_CPG_GERACAO IS NULL OR (MCC.MCC_IND_CPG_GERACAO = 'N'))
        AND (MCC.MCC_CRE = 0)) OR (MCC.MCC_IND_CPG_GERACAO = 'S')))

-------------------------------------------------------------------------
--Alteração da conta corrente

SELECT MCC_CCR, *
FROM MCC
WHERE  ((MCC.MCC_CPG_SERIE = 119)
        AND (MCC.MCC_CPG_NUM = 3393)
        AND (MCC.MCC_TIPO = 'P')
        AND (((MCC.MCC_IND_CPG_GERACAO IS NULL OR (MCC.MCC_IND_CPG_GERACAO = 'N'))
        AND (MCC.MCC_CRE = 0)) OR (MCC.MCC_IND_CPG_GERACAO = 'S')))

UPDATE MCC
SET MCC_CCR = '20002'
WHERE  ((MCC.MCC_CPG_SERIE = 119)
        AND (MCC.MCC_CPG_NUM = 3393)
        AND (MCC.MCC_TIPO = 'P')
        AND (((MCC.MCC_IND_CPG_GERACAO IS NULL OR (MCC.MCC_IND_CPG_GERACAO = 'N'))
        AND (MCC.MCC_CRE = 0)) OR (MCC.MCC_IND_CPG_GERACAO = 'S')))

-------------------------------------------------------------------------
--Alteração do Histórico da CFO (compromisso)

UPDATE mcc
SET mcc_obs = 'ALCON'
WHERE  ((MCC.MCC_CPG_SERIE = 119)
        AND (MCC.MCC_CPG_NUM = 3394)
        AND (MCC.MCC_TIPO = 'P')
        AND (((MCC.MCC_IND_CPG_GERACAO IS NULL OR (MCC.MCC_IND_CPG_GERACAO = 'N'))
        AND (MCC.MCC_CRE = 0)) OR (MCC.MCC_IND_CPG_GERACAO = 'S')))



-------------------------------------------------------------------------
--Alteração da CFO (compromisso)
UPDATE mcc
SET mcc_cfo_cod = 150
WHERE  ((MCC.MCC_CPG_SERIE = 119)
        AND (MCC.MCC_CPG_NUM = 3583)
        AND (MCC.MCC_TIPO = 'P')
        AND (((MCC.MCC_IND_CPG_GERACAO IS NULL OR (MCC.MCC_IND_CPG_GERACAO = 'N'))
        AND (MCC.MCC_CRE = 0)) OR (MCC.MCC_IND_CPG_GERACAO = 'S')))

-------------------------------------------------------------------------
--Inserção de CFO no compromisso

INSERT INTO mcc (mcc_ccr, mcc_lote, mcc_seq, mcc_doc, mcc_dt_proc, mcc_dt, mcc_mmyy, mcc_tipo, mcc_deb, mcc_cre, mcc_serie, mcc_cfo_cod,
                mcc_obs, mcc_cpg_serie, mcc_cpg_num, mcc_ipg_parc, mcc_str_cod, mcc_usr_login, mcc_cfo_estorno, mcc_fne_cod, mcc_cnv,
                mcc_nominal_a, mcc_ind_cpg_geracao, mcc_dt_emissao, mcc_concilia, mcc_gcc_cod, mcc_seq_contrap, mcc_cct_cod, mcc_proced,
                mcc_bcp_serie, mcc_bcp_num, mcc_qt_it, mcc_pti_cod, mcc_gr_ses_id, mcc_aee_id, mcc_seq_bcp_comp, mcc_cct_cpg_repasse, mcc_gcc_cod_ger)
VALUES ('9731', 107127, 2, '45568','2019-12-26 15:57:49.570','2019-12-26 15:58:17.153','201912','P','1063',0,1119,'2654',
        'PORTO ESTOQUE COMERCIO DE PROD HIGIENICO',1119,3867,2,'999','MEDICWARE',NULL,NULL,NULL,
        NULL,'S','2019-12-26 00:00:00.000','N',NULL,NULL,5925,'PAG-PTI',
        NULL,NULL,NULL,NULL,1841038,NULL,NULL,NULL,NULL)

