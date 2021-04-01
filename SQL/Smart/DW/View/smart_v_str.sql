CREATE VIEW 
	[dbo].[v_bi_str]
AS
SELECT
	str_cod,
	CASE
		WHEN str_str_cod IS NULL THEN '-1'
		ELSE str_str_cod
	END AS str_str_cod,
	CASE
		WHEN str_emp_cod IS NULL THEN -1
		ELSE str_emp_cod
	END AS str_emp_cod,
	str_nome,
	str_resp,
	CASE
		WHEN str_tipo = 'S' THEN 'SETOR'
		ELSE 'EMPRESA'
	END AS str_tipo,
	CASE
		WHEN str_status = 'A' THEN 'ATIVO'
		ELSE 'INATIVO'
	END AS str_status
FROM
	str