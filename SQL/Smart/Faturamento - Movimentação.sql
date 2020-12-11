SELECT mns.mns_dt,
    mns.mns_serie,
    mns.mns_num,
    mns.mns_nfs_numero,
    mns.mns_nfs_tipo,
    mns.mns_nfs_serie,
    mns.mns_dt_reg,
    mns.mns_usr_login,
    mns.mns_tipo,
    mns.mns_ind_liberado,
    mns.mns_lote,
    mns.mns_ccr_cod,
    mns.mns_vlr,
    mns.mns_dt_proc,
    mns.mns_obs,
    cfg.cfg_vlrfilme,
    mns.mns_nfl_num,
    mns.mns_ind_imposto_abater,
    mns.mns_vlr_complemento,
    nfs.nfs_nfl_num,
    mns.mns_nfl_serie,
    mns.mns_ind_abate_fluxo_previsto,
    mns.mns_vlr_glosa
FROM mns,
    cfg,
    nfs
WHERE (nfs.nfs_serie = mns.mns_nfs_serie)
    AND (nfs.nfs_numero = mns.mns_nfs_numero)
    AND (nfs.nfs_tipo = mns.mns_nfs_tipo)
    AND (mns.mns_nfs_numero = 57882)
    AND (mns.mns_nfs_tipo = 'NS')
    AND (mns.mns_nfs_serie = 'U')
    AND (mns.mns_tipo <> 'NR')
    AND (mns.mns_mns_serie IS NULL)
    AND (MNS.MNS_NUM = 17869)
--------------------------------------------------------
SELECT * 
FROM MNS 
WHERE (mns.mns_nfs_numero = 57882)
    AND (mns.mns_nfs_tipo = 'NS')
    AND (mns.mns_nfs_serie = 'U')
    AND (mns.mns_tipo <> 'NR')
    AND (mns.mns_mns_serie IS NULL)
    AND (MNS.MNS_NUM = 17869)
--------------------------------------------------------
DELETE FROM MNS 
WHERE (mns.mns_nfs_numero = 57882)
    AND (mns.mns_nfs_tipo = 'NS')
    AND (mns.mns_nfs_serie = 'U')
    AND (mns.mns_tipo <> 'NR')
    AND (mns.mns_mns_serie IS NULL)
    AND (MNS.MNS_NUM = 17869)


SELECT * FROM ext WHERE ext_mns_num = 17869 and ext_mns_serie = 119


