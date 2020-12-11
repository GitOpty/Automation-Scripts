SELECT emp.emp_nome_fantasia,
    emp.emp_cod,
    nfs.nfs_tipo,
    nfs.nfs_serie,
    nfs.nfs_numero,
    nfs.nfs_dt_emis,
    nfs.nfs_dt_vcto,
    nfs.nfs_valor,
    SUM(CASE WHEN mns.mns_tipo LIKE 'R%' THEN COALESCE(mns.mns_vlr, 0) ELSE 0 END) AS valor_recebido,
    emp.emp_prazo_recurso_glosa,
    (SELECT SUM(COALESCE(b.nfs_valor, 0))
        FROM nfs b
        WHERE b.nfs_nde_tipo = nfs.nfs_tipo
            AND b.nfs_nde_serie = nfs.nfs_serie
            AND b.nfs_nde_num = nfs.nfs_numero
            AND b.nfs_status <> 'C'
        ) AS valor_reapresentado,
    nfs.nfs_nde_tipo,
    nfs.nfs_nde_serie,
    nfs.nfs_nde_num,
    nfs.nfs_ns_tipo,
    nfs.nfs_ns_serie,
    nfs.nfs_ns_numero,
    nfs.nfs_lote,
    nfs.nfs_descr,
    nfs.nfs_remessa,
    nfs.nfs_carta_remessa,
    nfs.nfs_emp_cod,
    SUM(CASE WHEN mns.mns_tipo LIKE 'G%' THEN COALESCE(mns.mns_vlr, 0) ELSE COALESCE(mns.mns_vlr_glosa, 0) END) AS valor_glosado,
    MIN(CASE WHEN mns.mns_tipo LIKE 'G%' OR mns.mns_vlr_glosa <> 0 THEN mns.mns_dt ELSE GetDate() END) AS data_base_glosa,
    (SELECT SUM(COALESCE(e.ext_glosa_acatada, 0))
        FROM ext e,
            mns b
        WHERE (e.ext_mns_serie = b.mns_serie)
            AND (ext_mns_num = b.mns_num)
            AND (b.mns_nfs_tipo = nfs.nfs_tipo)
            AND (b.mns_nfs_numero = nfs.nfs_numero)
            AND (b.mns_nfs_serie = nfs.nfs_serie)
            AND (b.mns_tipo LIKE 'G%' OR b.mns_tipo LIKE 'R%')
            AND (b.mns_ind_liberado = 'S')
        ) AS valor_glosa_acatada
FROM emp,
    nfs,
    mns
WHERE (nfs.nfs_emp_cod = emp.emp_cod)
    AND (mns.mns_nfs_serie = nfs.nfs_serie)
    AND (mns.mns_nfs_numero = nfs.nfs_numero)
    AND (mns.mns_nfs_tipo = nfs.nfs_tipo)
    AND (nfs.nfs_tipo IN ('NS','NR'))
    AND (nfs.nfs_status <> 'C')
    AND (
        EXISTS (
            SELECT 1
            FROM mns b
            WHERE b.mns_nfs_tipo = nfs.nfs_tipo
                AND b.mns_nfs_serie = nfs.nfs_serie
                AND b.mns_nfs_numero = nfs.nfs_numero
            )
        )
    AND (mns.mns_ind_liberado = 'S')
GROUP BY emp.emp_cod,
    nfs.nfs_lote,
    nfs.nfs_emp_cod,
    nfs.nfs_descr,
    nfs.nfs_carta_remessa,
    nfs.nfs_remessa,
    nfs.nfs_nde_tipo,
    nfs.nfs_nde_serie,
    nfs.nfs_nde_num,
    nfs.nfs_ns_tipo,
    nfs.nfs_ns_serie,
    emp.emp_prazo_recurso_glosa,
    nfs.nfs_ns_numero,
    emp.emp_nome_fantasia,
    nfs.nfs_tipo,
    nfs.nfs_serie,
    nfs.nfs_numero,
    nfs.nfs_dt_emis,
    nfs.nfs_dt_vcto,
    nfs.nfs_valor