SELECT DISTINCT ETQ_SBA_COD
    , sba_nome
    , str_e.str_nome
    , ETQ_MAT_COD
    , gmm_nome
    , lma_nome
    , fne_nome_fantasia
    , mat_desc_resumida
    , etq_ident_lote
    , ETQ_QUANTIDADE 
    , ETQ_CML_PRECO_MEDIO
FROM etq  with (nolock)
LEFT JOIN mat  with (nolock)
    ON etq_mat_cod = mat_cod
LEFT JOIN gmm  with (nolock)
    ON gmm_cod = mat_gmm_cod
LEFT JOIN sba  with (nolock)
    ON sba_cod = etq_sba_cod
LEFT JOIN str with (nolock)
    ON str_cod = sba_str_cod
LEFT JOIN str str_e  with (nolock)
    ON str.str_str_cod = str_e.str_cod
LEFT JOIN mmc with (nolock)
    ON mmc_mat_cod = etq_MAT_COD
LEFT JOIN fne with (nolock)
    ON mat_fne_ult_entrada = FNE_COD
WHERE etq_mat_cod <> 0
