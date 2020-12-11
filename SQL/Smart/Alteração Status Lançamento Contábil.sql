--Consulta para selecionar os lançamento que será alterado o status, seja para cancelado ou ativo
SELECT * 
FROM LCT
WHERE LCT_LOTE = 55177
    AND LCT_SEQ IN (2, 4)

--Update para mudança de status do lançamento, seja para cancelado ou ativo
UPDATE LCT
SET LCT_DEL_LOGICA = 'S'
WHERE LCT_LOTE = 54060
    AND LCT_SEQ IN (3)

--Consulta para descobrir o nnúmero do lote
SELECT * FROM LCT WHERE lct_cpg_num = 3536 AND lct_cpg_serie = 120


