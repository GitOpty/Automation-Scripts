SELECT lct_lote  
FROM lct 
WHERE LCT_LOTE IN (4397,4398,8543,8553,8554,8555,8556,4399)

-----------------------------------------------------

DELETE 
FROM LCT
WHERE LCT_LOTE IN (4397,4398,8543,8553,8554,8555,8556,4399)

-----------------------------------------------------

SELECT LCT.LCT_LOTE, *
FROM LCT
LEFT JOIN CCT CCT_A
    ON LCT.LCT_CCT_COD_DEB = CCT_A.CCT_COD
LEFT JOIN CCT CCT_B
    ON LCT.LCT_CCT_COD_CRE = CCT_B.CCT_COD
LEFT JOIN GCC
    ON LCT.LCT_GCC_COD = GCC.GCC_COD
WHERE (LCT.LCT_DTHR >= '2019-01-01 00:00:00.000')
    AND (LCT.LCT_DTHR <= '2020-01-02 23:59:59.000')
    AND (LCT.LCT_GCC_COD LIKE '200')
    AND (
        ((LCT.LCT_LOTE = 4397))
        OR ((LCT.LCT_LOTE = 4398))
        OR ((LCT.LCT_LOTE = 8543))
        OR ((LCT.LCT_LOTE = 8553))
        OR ((LCT.LCT_LOTE = 8554))
        OR ((LCT.LCT_LOTE = 8555))
        OR ((LCT.LCT_LOTE = 8556))
        OR ((LCT.LCT_LOTE = 4399))
        )
ORDER BY LCT.LCT_LOTE ASC,
    LCT.LCT_SEQ ASC
