
CREATE VIEW
	[dbo].[v_bi_smk]
AS
SELECT
	smk_cod,
	smk_tipo,
    isnull(smk_amb,0) as smk_amb,
    smk_ctf,
	RTRIM(LTRIM(smk_rot)) AS smk_rot,
	RTRIM(LTRIM(smk_nome)) AS smk_nome
FROM
	smk