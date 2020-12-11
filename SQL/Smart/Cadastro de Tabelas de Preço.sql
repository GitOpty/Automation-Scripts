SELECT pre.pre_smk_cod,
    pre.pre_tab_cod,
    pre.pre_smk_tipo,
    pre.pre_umo_sigla,
    pre.pre_aux,
    pre.pre_porte,
    pre.pre_urg_p1,
    pre.pre_urg_p2,
    pre.pre_urg_p3,
    pre.pre_urg_p4,
    smk.smk_rot,
    smk.smk_ctf,
    ctf.ctf_nome,
    pre.pre_rx,
    pre.pre_ccv,
    pre.pre_tipo_preco_zero,
    pre.pre_filme_separado,
    pre.pre_urg_p5,
    pre.pre_vl_hon_1,
    pre.pre_vl_hon_2,
    pre.pre_vl_hon_3,
    pre.pre_vl_hon_4,
    pre.pre_vl_hon_5,
    pre.pre_vl_co_1,
    pre.pre_vl_co_2,
    pre.pre_vl_co_3,
    pre.pre_vl_co_4,
    pre.pre_vl_co_5,
    pre.pre_co_separado,
    pre.pre_cnv_descr,
    pre.pre_ind_export_zero,
    pre.pre_ccv_p1,
    pre.pre_ccv_p2,
    pre.pre_ccv_p3,
    pre.pre_ccv_p4,
    pre.pre_ccv_p5,
    pre.pre_vlr_p1,
    pre.pre_vlr_p2,
    pre.pre_vlr_p3,
    pre.pre_vlr_p4,
    pre.pre_vlr_p5,
    pre.pre_vl_copartic_1,
    pre.pre_vl_copartic_2,
    pre.pre_vl_copartic_3,
    pre.pre_vl_copartic_4,
    pre.pre_vl_copartic_5,
    pre.pre_origem_preco_mat,
    pre.pre_fator_brasindice,
    pre.pre_conta_fator_conv,
    pre.pre_fator_mult_tabmat,
    smk.smk_nome,
    pre.pre_vl_copartic_6,
    pre.pre_ccv_p6,
    pre.pre_vl_co_6,
    pre.pre_vl_hon_6,
    pre.pre_urg_p6,
    pre.pre_vlr_p6,
    pre.pre_uco_umo_sigla,
    pre.pre_num_tiss,
    ctf.ctf_categ,
    pre.pre_unm_cod,
    (
        SELECT MAX(a.pre_port)
        FROM abaprec a
        WHERE a.pre_smk_tipo = pre.pre_smk_tipo
            AND a.pre_smk_cod = pre.pre_smk_cod
            AND a.pre_port IS NOT NULL
        ) AS brasindice_lista,
    pre.pre_bras_preco_base,
    pre.pre_cod_despesa_tiss,
    pre.pre_cod_oper_coper,
    (
        SELECT cfg_uf
        FROM cfg
        ) AS cfg_uf,
    pre.pre_tipo_cobr,
    pre.pre_recateg,
    ctf.ctf_tipo
FROM pre,
    smk,
    ctf,
    tab
WHERE (smk.smk_tipo = pre.pre_smk_tipo)
    AND (smk.smk_cod = pre.pre_smk_cod)
    AND (ctf.ctf_tipo = smk.smk_tipo)
    AND (ctf.ctf_cod = smk.smk_ctf)
    AND (tab.tab_cod = pre.pre_tab_cod)
    AND (
        (pre.pre_tab_cod = '415')
        AND (smk.smk_status = 'A')
        AND (pre.pre_smk_tipo = 'M')
        AND (tab.tab_cod = '415')
        )
