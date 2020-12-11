--Consulta da NFS Lote para verificação dos registros
SELECT nfs_lote.nfs_l_lote
    , nfs_lote.nfs_l_guia
    , nfs_lote.nfs_l_nfs_tipo
    , nfs_lote.nfs_l_nfs_serie
    , nfs_lote.nfs_l_nfs_numero
    , nfs_lote.nfs_l_tp_guia
    , nfs_lote.nfs_l_dthr_reg
    , nfs_lote.nfs_l_usr_login
    , nfs_lote.nfs_l_protocolo
    , nfs_lote.nfs_l_gr_ses_id
    , nfs_lote.nfs_l_guia_operadora
FROM nfs_lote
WHERE (nfs_lote.nfs_l_nfs_tipo = 'NS')
    AND (nfs_lote.nfs_l_nfs_serie = 'U')
    AND (nfs_lote.nfs_l_nfs_numero = 999904129)

--Limpeza da tabela NFS Lote
BEGIN TRAN
DELETE
FROM nfs_lote
WHERE (nfs_lote.nfs_l_nfs_tipo = 'NS')
    AND (nfs_lote.nfs_l_nfs_serie = 'U')
    AND (nfs_lote.nfs_l_nfs_numero =  '')

--ROLLBACK
--COMMIT