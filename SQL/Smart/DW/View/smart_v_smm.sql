CREATE VIEW
	[dbo].[v_bi_smm]
AS
SELECT
    smm_dthr_alter as smm_dt_atualizacao,
	smm_dthr_exec,
	RTRIM(LTRIM(CAST(smm_osm_serie AS CHAR))) + RTRIM(LTRIM(CAST(smm_osm AS CHAR))) AS osm_fk,
	CASE
		WHEN RTRIM(LTRIM(CAST(smm_fat_serie AS CHAR))) + RTRIM(LTRIM(CAST(smm_fat AS CHAR))) IS NULL THEN '-1' 
		ELSE RTRIM(LTRIM(CAST(smm_fat_serie AS CHAR))) + RTRIM(LTRIM(CAST(smm_fat AS CHAR)))
	END AS fat_fk,
	CASE
		WHEN RTRIM(LTRIM(CAST(smm_mns_serie AS CHAR))) + RTRIM(LTRIM(CAST(smm_mns_num AS CHAR))) IS NULL THEN '-1' 
		ELSE RTRIM(LTRIM(CAST(smm_mns_serie AS CHAR))) + RTRIM(LTRIM(CAST(smm_mns_num AS CHAR)))
	END AS mns_fk,
	CASE
		WHEN RTRIM(LTRIM(CAST(smm_mte_serie AS CHAR))) + RTRIM(LTRIM(CAST(smm_mte_seq AS CHAR))) IS NULL THEN '-1' 
		ELSE RTRIM(LTRIM(CAST(smm_mte_serie AS CHAR))) + RTRIM(LTRIM(CAST(smm_mte_seq AS CHAR)))
	END AS mte_fk,
	CASE
		WHEN RTRIM(LTRIM(CAST(smm_rpi_serie AS CHAR))) + RTRIM(LTRIM(CAST(smm_rpi_num AS CHAR))) IS NULL THEN '-1' 
		ELSE RTRIM(LTRIM(CAST(smm_rpi_serie AS CHAR))) + RTRIM(LTRIM(CAST(smm_rpi_num AS CHAR)))
	END AS rpi_fk,

	CASE
		WHEN smm_pac_reg IS NULL THEN '-1'
		ELSE smm_pac_reg
	END AS smm_pac_reg,
	CASE
		WHEN smm_cnv_cod IS NULL THEN '-1'
		ELSE smm_cnv_cod
	END AS smm_cnv_cod,
	smm_str,
	smm_num,
	CASE
		WHEN smm_senha IS NULL THEN 'NÃO INFORMADO'
		WHEN smm_senha IN ('-', '.', '..', ' ') THEN 'NÃO INFORMADO'
		ELSE smm_senha
	END AS smm_senha,
	CASE
		WHEN smm_tiss_ind_guia_item IS NULL THEN 'NAO INFORMADO'
		ELSE smm_tiss_ind_guia_item
	END AS smm_tiss_ind_guia_item,
	CASE
		WHEN smm_tiss_guia_operadora IS NULL THEN 'NAO INFORMADO'
		ELSE smm_tiss_guia_operadora
	END AS smm_tiss_guia_operadora,
	smm_tpcod,
	smm_tipo_fatura,
    smm_cod,
	smm_exec,
    smm_hon_seq,
    smm_med,
    smm_canc_mot_cod,
    smm_motivo_cancela,
    smm_pacote,
    smm_sfat,
    smm_qt,
	smm_vlr,
    smm_ajuste_vlr
FROM
	smm (nolock)
WHERE 
	-- smm_dthr_exec >= '2015-01-01 00:00:00'
	smm_dthr_alter = dateadd(day,-1, getdate())
	AND (smm_pacote IS NULL OR smm_pacote = 'C')