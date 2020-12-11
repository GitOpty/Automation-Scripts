/*INSERT INTO mcc (
    mcc_ccr,
    mcc_lote,
    mcc_seq,
    mcc_doc,
    mcc_dt_proc,
    mcc_dt,
    mcc_mmyy,
    mcc_tipo,
    mcc_deb,
    mcc_cre,
    mcc_serie,
    mcc_cfo_cod,
    mcc_obs,
    mcc_cpg_serie,
    mcc_cpg_num,
    mcc_ipg_parc,
    mcc_str_cod,
    mcc_usr_login,
    mcc_cfo_estorno,
    mcc_fne_cod,
    mcc_cnv,
    mcc_nominal_a,
    mcc_ind_cpg_geracao,
    mcc_dt_emissao,
    mcc_concilia,
    mcc_gcc_cod,
    mcc_seq_contrap,
    mcc_cct_cod,
    mcc_proced,
    mcc_bcp_serie,
    mcc_bcp_num,
    mcc_qt_it,
    mcc_pti_cod,
    mcc_gr_ses_id,
    mcc_aee_id,
    mcc_seq_bcp_comp,
    mcc_cct_cpg_repasse,
    mcc_gcc_cod_ger
    )
VALUES (
    '88301',
    56389,
    1,
    '0',
    '2019-12-26 12:50:54.637',
    '2019-12-03 00:00:00.000',
    '201912',
    'R',
    0,
    71500,
    119,
    '178',
    'Transf Intercompany IOF para Oftalmoclin',
    NULL,
    NULL,
    NULL,
    '999',
    'GEOVANEHA',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    '2019-12-18 00:00:00.000',
    'N',
    '200',
    2,
    22280,
    'TES-ENT',
    NULL,
    NULL,
    NULL,
    NULL,
    1104637,
    NULL,
    NULL,
    NULL,
    NULL
    )
-----------------------------------------------------------
SELECT *
FROM mcc
WHERE mcc_lote = 56389
    AND mcc_serie = 119
-----------------------------------------------------------
SELECT CCR_SLD,
    CCR_REC,
    CCR_SINI,
    CCR_NAT,
    CCR_DINI
FROM CCR
WHERE (CCR_COD = '88301')
-----------------------------------------------------------
UPDATE CCR
SET CCR_SINI = 0,
    CCR_REC = 0,
    CCR_SLD = 1094600,
    CCR_DINI = '1900-01-01 00:00:00.000'

SELECT Getdate(),
    cfg_emp
FROM cfg
-----------------------------------------------------------
SELECT ccr_tit,
    ccr_tipo,
    ccr_dini,
    ccr_tcc_cod
FROM ccr
WHERE (ccr_cod = '88301')
-----------------------------------------------------------*/
INSERT INTO lct (lct_lote,lct_seq,lct_tipo,lct_dthr,lct_doc,lct_cct_cod_deb,lct_cct_cod_cre,lct_str_cod_deb,lct_str_cod_cre,lct_valor,lct_historico,lct_reg_usr_login,lct_reg_dthr,lct_reg_proced,lct_mcc_serie,lct_mcc_lote,lct_mcc_seq,lct_gcc_cod,lct_exc_id,lct_reg_tipo,lct_cpg_serie,lct_cpg_num,lct_ipg_parc,lct_nfs_tipo,lct_nfs_serie,lct_nfs_numero,lct_bcp_serie,lct_bcp_num,lct_nfl_serie,lct_nfl_num,lct_pti_cod,lct_emp_cod_titulo,lct_gr_ses_id,lct_mte_serie,lct_mte_seq,lct_rdi_seq,lct_mns_serie,lct_mns_num,LCT_CONTRAPARTIDA)
VALUES (
    8538,
    1,
    'S',
    '2019-12-03 00:00:00.000',
    '0',
    18480,
    22280,
    NULL,
    NULL,
    71500,
    'OUTROS LANCAMENTOS  doc 0BANCO SANTANDER <CP_OBS>',
    'GEOVANEHA',
    '2019-12-26 12:51:58.167',
    'EXP',
    119,56389,2,'200',2,'T-I',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
    1104637,
    NULL,NULL,NULL,NULL,NULL,NULL)


