-- Consulta para verificar compromissos que não contabilizaram

SELECT  cpg_serie as serie,
        cpg_num as número,
        cpg_gcc_cod as empresa,
        cpg_doc as documento,
        cpg_credor as credor,
        cpg_cct_cod_passivo as cc_passivo,
        cpg_dt_contab as dt_contabilização,
        ipg_valor as vl_bruto,
        mcc_cfo_cod as cfo,
        mcc_cct_cod as cc_cfo,
        cpg_export_contab as exp_contab
FROM    cpg, 
        ipg,
        mcc
WHERE   cpg_num = ipg_cpg_num AND cpg_serie = ipg_cpg_serie
        AND mcc.mcc_cpg_num = cpg_num AND mcc_cpg_serie = cpg_serie
        AND cpg_dt_reg between '2019-11-28 00:00:00.000' AND '2019-12-06 00:00:00.000'
        AND cpg_tipo_compromisso not in ('I')
        AND ipg_status not in ('C','A')
        AND CPG_EXPORT_CONTAB is null        
        AND cpg_num not in (SELECT DISTINCT lct_cpg_num FROM lct WHERE lct_cpg_num IS NOT NULL)
ORDER BY 2