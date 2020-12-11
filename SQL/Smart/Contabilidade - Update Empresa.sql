-------------------------------------------------------------------------------------------------------------
/*                                              CONSULTAS                                                  */
-------------------------------------------------------------------------------------------------------------

-- Consulta para verificar os lançamentos contábeis em conta débito/crédito de determinado código e empresa:
SELECT * 
FROM lct 
WHERE lct.lct_cct_cod_deb = 10730
    AND lct.lct_gcc_cod LIKE '4'
    AND (lct.lct_dthr >= '2019-10-01 00:00:00.000')
    AND (lct.lct_dthr <= '2019-10-31 00:00:00.000')
-------------------------------------------------------------------------------------------------------------
SELECT *
FROM lct
WHERE lct.lct_cct_cod_deb = 10730
    AND (LCT.lct_exc_id = 15)
    AND (lct.lct_dthr >= '2019-10-01 00:00:00.000')
    AND (lct.lct_dthr <= '2019-10-31 00:00:00.000')

-------------------------------------------------------------------------------------------------------------
/*                                              UPDATES                                                    */
-------------------------------------------------------------------------------------------------------------

-- Update para alterar nos lançamentos contábeis em conta débito/crédito a empresa do lançamento:
UPDATE LCT
SET lct.lct_gcc_cod = 'DHI'
WHERE lct.lct_cct_cod_deb = 10730
    AND lct.lct_gcc_cod LIKE '4'
    AND (lct.lct_dthr >= '2019-10-01 00:00:00.000')
    AND (lct.lct_dthr <= '2019-10-31 00:00:00.000')
-------------------------------------------------------------------------------------------------------------
UPDATE LCT
SET LCT.lct_exc_id = 1
WHERE lct.lct_cct_cod_deb = 10730
    AND (LCT.lct_exc_id = 15)
    AND (lct.lct_dthr >= '2019-10-01 00:00:00.000')
    AND (lct.lct_dthr <= '2019-10-31 00:00:00.000')