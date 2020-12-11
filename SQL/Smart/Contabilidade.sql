SELECT *
FROM lct

--update LCT
--set LCT_CCT_COD_CRE = '12140'
WHERE lct_lote IN (

        SELECT LCT_LOTE
        FROM LCT
        WHERE (lct.lct_dthr >= '2019-07-01 00:00:00.000')
            AND (lct.lct_dthr <= '2019-07-31 23:59:59.000')
            AND (lct.lct_gcc_cod LIKE 'DHI')
            --AND (lct.lct_cct_cod_cre is null)
            AND (LCT_CCT_COD_DEB = '12130')
            
        )
    --AND LCT_CCT_COD_DEB = '12120'
    --AND LCT_CCT_COD_DEB is null
    AND lct.lct_gcc_cod LIKE 'DHI'
    AND (LCT_DEL_LOGICA = 'N')
    and LCT_CCT_COD_CRE = '0'
    --AND LCT_LOTE = '47102'

--ORDER BY 1

--------------------------------------------------------------------------------------------------

SELECT *
FROM LCT
WHERE lct.lct_dthr >= '2019-07-01 00:00:00.000'
      AND lct.lct_dthr <= '2019-07-31 23:59:59.000'
      AND lct.lct_gcc_cod = '1'
      AND lct.LCT_CCT_COD_CRE = '40300'
      AND lct.LCT_LOTE = '59054'

--AND LCT_DEL_LOGICA = 'N'
SELECT *
FROM gcc
