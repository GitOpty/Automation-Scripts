CREATE VIEW
	[dbo].[v_bi_cnv]
AS

SELECT 
	
	[cnv_cod],
	
	CASE
		WHEN [cnv_emp_cod] IS NULL THEN -1
		ELSE [cnv_emp_cod]
	END AS [cnv_emp_cod],
    
    emp.emp_cgc, 

	[cnv_nome],
	
	CASE
		WHEN [cnv_rsoc] IS NULL THEN 'NAO INFORMADO'
		WHEN [cnv_rsoc] = ' ' THEN 'NAO INFORMADO'
		ELSE [cnv_rsoc]
	END AS [cnv_rsoc],
    
	CASE 
		WHEN [cnv_stat] = 'A' THEN 'ATIVO'
		WHEN [cnv_stat] = 'C' THEN 'CANCELADO'
		WHEN [cnv_stat] = 'S' THEN 'SUSPENSO'
	END AS [cnv_stat],
    
	CASE
		WHEN [cnv_tipo] = 'AM' THEN 'AMBULATORIAL'
		WHEN [cnv_tipo] = 'HP' THEN 'HOSPITALAR'
		WHEN [cnv_tipo] = 'AH' THEN 'AMBULAT/HOSP'
		ELSE 'MEDICINA OCUPACIONAL'
	END AS [cnv_tipo],

	CASE
		WHEN [cnv_caixa_fatura] = 'B' THEN 'BENEFICENCIA'
		WHEN [cnv_caixa_fatura] = 'C' THEN 'CAIXA'
		WHEN [cnv_caixa_fatura] = 'F' THEN 'FATURA'
		ELSE 'SUS'
	END AS [cnv_caixa_fatura]
    ,cnv_reg_ans

FROM
	cnv 
INNER JOIN emp on emp_cod = cnv_emp_cod

