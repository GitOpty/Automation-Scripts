--Alteração de status de compromisso:
UPDATE IPG
SET IPG_STATUS = 'R'
WHERE IPG_CPG_NUM = 3395 AND IPG_CPG_SERIE = 119

--Consulta do título:
SELECT * FROM IPG WHERE IPG_CPG_NUM = 3899 AND IPG_CPG_SERIE = 119