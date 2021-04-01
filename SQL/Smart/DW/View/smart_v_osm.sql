CREATE VIEW 
	[dbo].[v_bi_osm]
AS
SELECT
	osm_dthr,
	osm_dt_result,
	RTRIM(LTRIM(CAST(osm_serie AS CHAR))) + RTRIM(LTRIM(CAST(osm_num AS CHAR))) AS osm_pk,
	osm_num,
	osm_serie,
	osm_cnv,
	osm_pac,
	osm_atend,
	osm_leg_cod,
	osm_mreq,
	osm_pln_cod,
	osm_proc,
	CASE
		WHEN osm_psv_indic IS NULL THEN -1
		ELSE osm_psv_indic
	END AS osm_psv_indic,
	CASE	
		WHEN osm_ctle_cnv IS NULL THEN 'NAO INFORMADO'
		ELSE osm_ctle_cnv
	END AS osm_ctle_cnv,
	osm_str,
	CASE
		WHEN osm_status IS NULL THEN '-1'
		ELSE osm_status
	END AS osm_status
FROM
	osm
WHERE 
	osm_dthr >= '2015-01-01 00:00:00'


	