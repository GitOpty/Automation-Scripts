CREATE VIEW
	[dbo].[v_bi_fat]
AS
SELECT
	fat_dini,
	fat_dfin,
	CASE
		WHEN RTRIM(LTRIM(CAST(fat_nfs_numero AS CHAR))) + RTRIM(LTRIM(fat_nfs_tipo)) + RTRIM(LTRIM(fat_nfs_serie)) IS NULL THEN '-1'
		ELSE RTRIM(LTRIM(CAST(fat_nfs_numero AS CHAR))) + RTRIM(LTRIM(fat_nfs_tipo)) + RTRIM(LTRIM(fat_nfs_serie))
	END AS nfs_fk,
	CASE
		WHEN fat_cnv = ' ' THEN '-1'
		ELSE fat_cnv
	END AS fat_cnv,
	CASE
		WHEN fat_emp_cod IS NULL THEN '-1'
		ELSE fat_emp_cod
	END AS fat_emp_cod,
	CASE
		WHEN fat_hsp_pac IS NULL THEN '-1'
		ELSE fat_hsp_pac
	END AS fat_hsp_pac,
	CASE
		WHEN fat_str_cod_sol IS NULL THEN '-1'
		ELSE fat_str_cod_sol
	END AS fat_str_cod_sol,
	CASE
		WHEN fat_str_cod_exe IS NULL THEN '-1'
		ELSE fat_str_cod_exe
	END AS fat_str_cod_exe,
	RTRIM(LTRIM(CAST(fat_serie AS CHAR))) + RTRIM(LTRIM(CAST(fat_num AS CHAR))) AS fat_pk,
	fat_serie,
	fat_num,
	fat_stat,
	CASE
		WHEN fat_val IS NULL THEN 0
		ELSE fat_val
	END AS fat_val,
	CASE
		WHEN fat_sld IS NULL THEN 0
		ELSE fat_sld
	END AS fat_sld
FROM
	fat (nolock)
WHERE
	fat_dini >= '2015-01-01 00:00:00'