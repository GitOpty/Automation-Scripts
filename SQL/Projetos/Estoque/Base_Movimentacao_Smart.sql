SELECT DISTINCT MMA_TIPO_OPERACAO
    , mma_data_mov
    , MMA_SBA_COD
    , sba_nome
    , str_e.str_nome
    , mma_mat_cod
    , mma_ism_seq
    , MMA_ISM_SEQ
    , mma_lot_num
    , gmm_nome
    , fne_nome_fantasia
    , mat_desc_resumida
    , tmm_descr
    , tmm_tipo
    , mma_qtd
    , mma_valor
FROM mma with (nolock)
LEFT JOIN tmm  with (nolock)
    ON tmm_cod = MMA_TIPO_OPERACAO
LEFT JOIN mat with (nolock)
    ON mma_mat_cod = mat_cod
LEFT JOIN gmm with (nolock)
    ON gmm_cod = mma_gmm_cod
LEFT JOIN sba with (nolock)
    ON sba_cod = mma_sba_cod
LEFT JOIN str with (nolock)
    ON str_cod = sba_str_cod
LEFT JOIN str str_e  with (nolock)
    ON str.str_str_cod = str_e.str_cod
LEFT JOIN fne  with (nolock)
    ON mat_fne_ult_entrada = FNE_COD
WHERE mma_data_mov >= '01/01/2020'
