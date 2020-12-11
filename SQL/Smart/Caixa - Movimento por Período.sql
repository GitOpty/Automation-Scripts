SELECT 
    mte.mte_serie as Movimento_Série,
    mte.mte_seq as Movimento_Número,
    pac.pac_tit as Paciente,
    mte.mte_osm_serie as OS_Série,
    mte.mte_osm as OS_Número,
    mte.mte_dthr as Data_Registro,
    mte.mte_usr_login as Usuário,    (SELECT SUM(udp.udp_valor)
        FROM udp
        WHERE udp.udp_mte_serie_dep = mte.mte_serie AND udp.udp_mte_seq_dep = mte.mte_seq
        ) AS Externo,
    mte.mte_desconto as Desconto    
FROM mte
LEFT JOIN nfs 
    ON mte.mte_nfs_numero = nfs.nfs_numero
        AND mte.mte_nfs_tipo = nfs.nfs_tipo
        AND mte.mte_nfs_serie = nfs.nfs_serie
LEFT JOIN str
    ON mte.mte_str_recep = str.str_cod
LEFT JOIN pac
    ON mte.mte_pac_reg = pac.pac_reg, cfg

WHERE (mte.mte_serie = 119)
    --and(mte.mte_dthr > 01/09/2019)
    --and pac.pac_tit is not null
    AND (mte.mte_seq = 20734)


ORDER BY 3