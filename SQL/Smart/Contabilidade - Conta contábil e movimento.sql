-- Consulta para verificar as movimentações realizadas com conta corrente selecionada
SELECT mcc_cct_cod, * 
FROM mcc 
WHERE mcc_ccr = '20002' 
    AND mcc_tipo = 'P' 
    AND mcc_cct_cod is not null
    AND mcc_cct_cod = 280

-- Consulta para verificar as movimentações sem conta corrente
SELECT mcc_cct_cod, * 
FROM mcc
WHERE mcc_ccr = '20002' 
    AND mcc_tipo = 'P' 
    AND mcc_cct_cod is null

-- Consulta para verificar todos os movimentos relacionados a conta corrente selecionada
SELECT mcc_cct_cod, * 
FROM mcc
WHERE mcc_cct_cod is not null

-- Update para alterar as movimentações e deixar sem conta corrente
UPDATE mcc
SET mcc_cct_cod = null
WHERE mcc_ccr = '20002' 
    AND mcc_tipo = 'P' 
    AND mcc_cct_cod is not null
    AND mcc_cct_cod = 280

-- Delete da conta contábil
DELETE 
FROM cct 
WHERE cct_cod = 2
-----------------------------------------------------------------------------------------------------------------
UPDATE mcc
SET mcc_cct_cod = null
WHERE mcc_cct_cod is not null
-----------------------------------------------------------------------------------------------------------------
SELECT mcc_cct_cod, mcc_lote, mcc_seq, mcc_serie, mcc_ccr, mcc_cpg_num FROM mcc WHERE mcc_cct_cod is not null
-----------------------------------------------------------------------------------------------------------------
SELECT * FROM cct
-----------------------------------------------------------------------------------------------------------------
SELECT top 10 CCR_CCT_COD, * FROM ccr,cct WHERE CCR_CCT_COD = cct.cct_cod

UPDATE ccr
SET CCR_CCT_COD = null
where ccr_cod in (88279, 88297) 

select CCR_CCT_COD from ccr where ccr_cod in (88279, 88297)
-----------------------------------------------------------------------------------------------------------------
SELECT CFO_CCT_COD, * from cfo WHERE CFO_CCT_COD is not null

UPDATE cfo
set CFO_CCT_COD = null
WHERE CFO_CCT_COD is not null
-----------------------------------------------------------------------------------------------------------------
SELECT emp_cct_cod, emp_cct_cod_ativo, * FROM emp WHERE emp_cct_cod_ativo is not null

UPDATE emp
SET emp_cct_cod_ativo = null
WHERE emp_cct_cod_ativo is not null