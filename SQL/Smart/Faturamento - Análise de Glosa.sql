SELECT emp.emp_nome_fantasia as Convênio,
    emp.emp_cod as Cod_Convênio,
    nfs.nfs_tipo as Tipo,
    nfs.nfs_serie as Série,
    nfs.nfs_numero as Número,
    nfs.nfs_dt_emis as DT_Emissão,
    nfs.nfs_dt_vcto as DT_Vencimento,
    nfs.nfs_valor as Valor,
    SUM(CASE WHEN mns.mns_tipo LIKE 'R%' THEN COALESCE(mns.mns_vlr, 0) ELSE 0 END) AS Valor_Recebido,
    emp.emp_prazo_recurso_glosa as Prazo_Recurso_Glosa,
    (SELECT SUM(COALESCE(b.nfs_valor, 0)) 
        FROM nfs b 
        WHERE b.nfs_nde_tipo = nfs.nfs_tipo 
            AND b.nfs_nde_serie = nfs.nfs_serie 
            AND b.nfs_nde_num = nfs.nfs_numero 
            AND b.nfs_status <> 'C'
        ) AS Valor_Reapresentado,
    nfs.nfs_nde_tipo as Tipo,
    nfs.nfs_nde_serie as Série,
    nfs.nfs_nde_num as Número,
    nfs.nfs_ns_tipo as NS_Tipo,
    nfs.nfs_ns_serie as NS_Série,
    nfs.nfs_ns_numero as NS_Número,
    nfs.nfs_lote as Lote,
    nfs.nfs_descr as Descrição,
    nfs.nfs_emp_cod as Cod_Convênio,
    SUM(CASE WHEN mns.mns_tipo LIKE 'G%' THEN COALESCE(mns.mns_vlr, 0) ELSE COALESCE(mns.mns_vlr_glosa, 0) END) AS Valor_Glosado,
    MIN(CASE WHEN mns.mns_tipo LIKE 'G%' OR mns.mns_vlr_glosa <> 0 THEN mns.mns_dt ELSE GetDate() END) AS Data_Base_Glosa,
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
        ) AS Valor_Glosa_Acatada,
    mns.mns_dt_proc as DT_Processamento,
    nfs.nfs_usr_login as Usuário,
    (select sum(x.MNS_VLR)
        from mns x
        where MNS_NFS_NUMERO = nfs_numero
            and MNS_NFS_SERIE = nfs_serie
            and MNS_NFS_TIPO = nfs_tipo
            and mns_tipo LIKE 'R%'
            /*and x.MNS_DT between nfs_dt_emis and '2019-06-30 00:00:00.000'*/) Valor_Total_Baixado, 
    (select max(x.MNS_DT)
        from mns x
        where MNS_NFS_NUMERO = nfs_numero
            and MNS_NFS_SERIE = nfs_serie
            and MNS_NFS_TIPO = nfs_tipo
            and mns_tipo LIKE 'R%'
            /*and x.MNS_DT between nfs_dt_emis and '2019-06-30 00:00:00.000'*/) DT_Baixa 
FROM emp,
    nfs,
    mns
WHERE (nfs.nfs_emp_cod = emp.emp_cod)
    AND (nfs.nfs_serie = mns.mns_nfs_serie)
    AND (mns.mns_nfs_serie = nfs.nfs_serie)
    AND (mns.mns_nfs_numero = nfs.nfs_numero)
    AND (mns.mns_nfs_tipo = nfs.nfs_tipo)
    AND (nfs.nfs_tipo IN ('NS', 'NR'))
    AND (nfs.nfs_status <> 'C')
    AND (EXISTS (
            SELECT 1
            FROM mns b
            WHERE b.mns_nfs_tipo = nfs.nfs_tipo
                AND b.mns_nfs_serie = nfs.nfs_serie
                AND b.mns_nfs_numero = nfs.nfs_numero
                /*AND b.mns_dt >= '2019-01-01 00:00:00.000'
                AND b.mns_dt <= '2019-09-10 23:59:59.000'*/
                AND (b.mns_tipo LIKE 'G%' OR (b.mns_tipo LIKE 'R%' AND b.mns_vlr_glosa <> 0))
                AND b.mns_ind_liberado = 'S'
            )
        )
    AND (mns.mns_ind_liberado = 'S')
GROUP BY emp.emp_cod,
    nfs.nfs_lote,
    nfs.nfs_emp_cod,
    nfs.nfs_descr,
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
    nfs.nfs_valor,
    nfs_usr_login,
    mns.mns_dt_proc,
    nfs.nfs_dt_receb,
    mns.mns_vlr_glosa,
    nfs.nfs_usr_login 
/*
SELECT * FROM mns WHERE mns_nfs_tipo like 'NR'
ORDER by 7 desc
*/ 