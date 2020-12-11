--Consulta para verificar os títulos do borderô
SELECT *
FROM ipg
WHERE (ipg.ipg_bcp_serie = 120) AND (ipg.ipg_bcp_num = 993)        

--Inclusão do título no borderô
UPDATE ipg
set ipg_bcp_serie = 120
WHERE (ipg_cpg_serie = 120) AND (ipg_cpg_num = 8067)    

UPDATE ipg
set ipg_bcp_num = 993
WHERE (ipg_cpg_serie = 120) AND (ipg_cpg_num = 8067)

--Remoção do título do borderô
update ipg
set ipg_bcp_serie = null
WHERE (ipg_cpg_serie = 120) AND (ipg_cpg_num = 6467)

update ipg
set ipg_bcp_num = null
WHERE (ipg_cpg_serie = 120) AND (ipg_cpg_num = 6467)

--Consunta do registro do título
SELECT ipg_bcp_serie
    , ipg_bcp_num
    , ipg_cpg_serie
    , ipg_cpg_num
    , ipg_status
FROM ipg 
WHERE ipg_cpg_serie = 120 AND ipg_cpg_num = 5094

--Alteração de status de compromisso:
UPDATE IPG
SET IPG_STATUS = 'P'
WHERE IPG_CPG_NUM = 8067 AND IPG_CPG_SERIE = 120

--Consulta do título:
SELECT * FROM IPG WHERE IPG_CPG_NUM = 8067 AND IPG_CPG_SERIE = 120

UPDATE ipg
set ipg_dt_vcto = '2020-07-16 12:29:22.037'
WHERE IPG_CPG_NUM = 8067 AND IPG_CPG_SERIE = 120

UPDATE ipg
set ipg_dt_pgto = '2020-07-16 12:29:22.037'
WHERE IPG_CPG_NUM = 8067 AND IPG_CPG_SERIE = 120

--CPG
SELECT * FROM cpg WHERE cpg_serie = 120 AND cpg_num = 8067

UPDATE cpg
SET cpg_yymm_competencia = 202007
WHERE cpg_serie = 120 AND cpg_num = 8067

UPDATE cpg
set cpg_dt_reg = '2020-07-13 12:00:22.037'
WHERE CPG_NUM = 8067 AND CPG_SERIE = 120

UPDATE cpg
set cpg_dt_doc_emiss = '2020-07-13 12:05:22.037'
WHERE CPG_NUM = 8067 AND CPG_SERIE = 120

UPDATE cpg
set CPG_AUT_DTHR = '2020-07-13 12:05:22.037'
WHERE CPG_NUM = 8067 AND CPG_SERIE = 120

UPDATE cpg
set CPG_USR_LOGIN = 'MEDICWARE'
WHERE CPG_NUM = 8067 AND CPG_SERIE = 120




SELECT * from mcc WHERE mcc_cpg_serie = 120 and mcc_cpg_num = 8067

UPDATE mcc
SET mcc_dt_proc = '2020-07-13 12:05:22.037'
WHERE mcc_cpg_serie = 120 and mcc_cpg_num = 8067


