SELECT nfs.nfs_serie,
    nfs.nfs_numero,
    nfs.nfs_dt_vcto,
    nfs.nfs_valor,
    cnv.cnv_nome,
    nfs.nfs_tipo,
    nfs.nfs_desconto,
    nfs.nfs_perc_multa,
    nfs.nfs_vlr_multa,
    nfs.nfs_status,
    nfs.nfs_dt_emis,
    emp.emp_raz_soc,
    nfs.nfs_emp_codigo,
    nfs.nfs_nde_serie,
    nfs.nfs_nde_tipo,
    nfs.nfs_nde_num,
    nfs.nfs_perc_iss,
    nfs.nfs_perc_ir,
    nfs.nfs_vlr_iss,
    nfs.nfs_vlr_ir,
    nfs.nfs_perc_juro,
    nfs.nfs_nfl_num,
    nfs.nfs_usr_login,
    nfs.nfs_dt_envio,
    emp.emp_nome_fantasia,
    nfs.nfs_dt_receb,
    nfs.nfs_fluxo_caixa,
    nfs.nfs_ind_tipo_fatura,
    nfs.nfs_iss_ret,
    nfs.nfs_ir_ret,
    nfs.nfs_cssl_ret,
    nfs.nfs_cofins_ret,
    nfs.nfs_pis_ret,
    nfs.nfs_vlr_cssl,
    nfs.nfs_vlr_cofins,
    nfs.nfs_vlr_pis,
    nfs.nfs_vlr_outros_imp,
    str.str_nome,
    nfs.nfs_remessa,
    nfs.nfs_emp_cod,
    nfs.nfs_str_cod,
    emp.emp_cr_modelo_import,
    emp.emp_cnv_cod,
    nfs.nfs_nfl_serie,
    nfl.nfl_rps_numero,
    nfl.nfl_rps_serie,
    nfx.nfx_numero,
    (SELECT e.emp_nome_fantasia FROM emp e WHERE str.str_emp_cod = e.emp_cod) empresa
FROM nfs
    LEFT JOIN nfl ON nfs.nfs_nfl_serie = nfl.nfl_serie AND nfs.nfs_nfl_num = nfl.nfl_num
    LEFT JOIN nfx ON nfs.nfs_nfl_serie = nfx.nfx_nfl_serie AND nfs.nfs_nfl_num = nfx.nfx_nfl_num, cnv, emp, str
WHERE (nfs.nfs_emp_cod = emp.emp_cod)
    AND (cnv.cnv_cod = nfs.nfs_emp_codigo)
    AND (str.str_cod = nfs.nfs_str_cod)
    AND (nfs_status <> 'C')
    AND (nfs.nfs_tipo <> 'NC')
    AND (nfs.nfs_dt_vcto >= '2020-02-01 00:00:00.000')
    AND (nfs.nfs_dt_vcto <= '2020-02-29 23:59:00.000')
    AND (NOT EXISTS (SELECT 1 FROM cnv b WHERE b.cnv_emp_cod = emp.emp_cod AND b.cnv_caixa_fatura = 'B'))
ORDER BY nfs.nfs_dt_emis DESC,
    nfs.nfs_serie ASC,
    nfs.nfs_numero DESC