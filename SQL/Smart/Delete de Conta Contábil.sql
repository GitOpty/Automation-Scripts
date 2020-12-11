SELECT *
FROM CCT
WHERE (CCT.CCT_COD <> 0)
    AND (((CCT.CCT_COD = 1395)))

DELETE
FROM CCT
WHERE (CCT.CCT_COD <> 0)
    AND (((CCT.CCT_COD = 1395)))
----------------------------------------------------------
SELECT *
FROM exc_saldo_ini
WHERE ((exc_saldo_ini.exc_s_exc_id = 23))
    AND exc_saldo_ini.exc_s_cct_cod = 1395

DELETE 
FROM exc_saldo_ini
WHERE ((exc_saldo_ini.exc_s_exc_id = 23))
    AND exc_saldo_ini.exc_s_cct_cod = 1395
----------------------------------------------------------


/*SELECT LCT_CCT_COD_CRE, * FROM LCT
WHERE LCT_CCT_COD_CRE = 1395
ORDER BY LCT_DTHR


DELETE 
FROM LCT
WHERE LCT_CCT_COD_CRE = 1395*/
