SELECT top 50 NFS_VALOR, *
FROM NFS
WHERE (NFS_STATUS <> 'R')
    AND (NFS.NFS_TIPO <> 'NR')
    AND (NFS.NFS_DT_VCTO >= '2019-01-01 00:00:00.000')
    AND (NFS.NFS_DT_VCTO <= '2020-09-30 23:59:59.000')
    AND (NFS.NFS_NUMERO = 999906236)
------------------------------------------------------------
SELECT nfs_valor, *
FROM nfs
WHERE ((nfs.nfs_tipo = 'NR')
        AND (((nfs.nfs_numero = 999906236))))
------------------------------------------------------------
UPDATE NFS
SET NFS_VALOR = 2359.46
WHERE ((nfs.nfs_tipo = 'NR')
        AND (((nfs.nfs_numero = 10657))))
------------------------------------------------------------
DELETE
FROM nfs
WHERE ((nfs.nfs_tipo = 'NR')
        AND (((nfs.nfs_numero = 999906236))))
------------------------------------------------------------
SELECT * FROM MNS
WHERE MNS_NFS_TIPO = 'NR' AND MNS_NFS_NUMERO = 999906236

DELETE
FROM mns
WHERE MNS_NFS_TIPO = 'NR' AND MNS_NFS_NUMERO = 999906236
------------------------------------------------------------
SELECT *
FROM glf
WHERE glf_mns_serie = 120 and glf_mns_num = 18207

DELETE
FROM glf
WHERE glf_mns_serie = 120 and glf_mns_num = 18207
------------------------------------------------------------
SELECT *
FROM ext
WHERE ext_mns_serie = 120 and ext_mns_num = 18207

DELETE
FROM ext
WHERE ext_mns_serie = 120 and ext_mns_num = 18207