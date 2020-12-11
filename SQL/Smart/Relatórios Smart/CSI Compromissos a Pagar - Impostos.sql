select LTRIM(LEFT(CPG.CPG_CREDOR, PATINDEX('% %', CPG.CPG_CREDOR))) AS CPG_IMPOSTO,
    LTRIM(REPLACE(CPG.CPG_CREDOR, LTRIM(LEFT(CPG.CPG_CREDOR, PATINDEX('%-%', CPG.CPG_CREDOR))), '')) AS CPG_EMPRESA,
    CPG.CPG_GCC_COD,
    GCC.GCC_DESCR,
    CPG.CPG_CREDOR,
    CPG.CPG_DOC,
    IPG.IPG_VALOR,
    IPG.IPG_VALOR_COMPLEMENTO,
    IPG.IPG_VALOR_CPG_DESC,
    IPG.IPG_VALOR_CPG_DESP_AC,
    IPG.IPG_VALOR_MULTA,
    IPG.IPG_DT_PGTO,
    CPG.CPG_SERIE,
    CPG.CPG_NUM,
    IPG.IPG_STATUS,
    CPG.CPG_FIS_JUR,
    IPG.IPG_BCP_SERIE,
    IPG.IPG_BCP_NUM,
    BCP.BCP_DTHR,
    BCP.BCP_TIPO_PAG,
    CPG.CPG_DT_DOC_EMISS,
    CONVERT(VARCHAR, IPG.IPG_DT_VCTO, 103) AS IPG_DT_VCTO
FROM IPG WITH (NOLOCK),  BCP WITH (NOLOCK),  CPG WITH (NOLOCK),  GCC
 WITH (NOLOCK) WHERE  BCP.BCP_SERIE = IPG.IPG_BCP_SERIE AND BCP.BCP_NUM = IPG.IPG_BCP_NUM
	AND CPG.CPG_SERIE = IPG.IPG_CPG_SERIE AND CPG.CPG_NUM = IPG.IPG_CPG_NUM
	AND GCC.GCC_COD = CPG.CPG_GCC_COD
	AND ((ipg.ipg_status in ('P') ) or ('0' in ('P')))
	and (ipg.ipg_dt_vcto >= '11-1-2019 0:0:0.000') 
	and (ipg.ipg_dt_vcto <= '12-27-2019 23:59:59.000') 
	and (cpg.cpg_tipo_compromisso like 'I') 
	and (cpg.cpg_gcc_cod like '10' or (ipg.ipg_gcc_cod_colig = '10'))
	and cpg.cpg_fis_jur = 'J'
ORDER BY LTRIM(LEFT(CPG.CPG_CREDOR, PATINDEX('% %', CPG.CPG_CREDOR))),
    GCC.GCC_DESCR,
    IPG.IPG_DT_VCTO
 OPTION ( LOOP JOIN, MAXDOP 1 ) 
------------------------------------------------------------------------------------------------------------------------------------------

select 'A' as c1,'Aberto' as c2
union
select 'R' as c1,'Registrado' as c2
union
select 'P' as c1,'Pago' as c2
union
select 'C' as c1,'Cancelado' as c2
union
select 'N' as c1,'Negociado' as c2
------------------------------------------------------------------------------------------------------------------------------------------

select day_imp as c1, day_imp as c2 from day_imp
------------------------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[day_imp](
	[day_imp] [varchar](50) NOT NULL,
 CONSTRAINT [PK_day_imp] PRIMARY KEY CLUSTERED 
(
	[day_imp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO day_imp (day_imp) VALUES ('COFINS')
INSERT INTO day_imp (day_imp) VALUES ('CSLL')
INSERT INTO day_imp (day_imp) VALUES ('FGTS')
INSERT INTO day_imp (day_imp) VALUES ('INSS')
INSERT INTO day_imp (day_imp) VALUES ('IPTU')
INSERT INTO day_imp (day_imp) VALUES ('IRPJ')
INSERT INTO day_imp (day_imp) VALUES ('IRRF')
INSERT INTO day_imp (day_imp) VALUES ('ISS')
INSERT INTO day_imp (day_imp) VALUES ('PCC')
INSERT INTO day_imp (day_imp) VALUES ('PIS')
------------------------------------------------------------------------------------------------------------------------------------------

ALTER DATABASE smart_teste SET COMPATIBILITY_LEVEL = 100;
------------------------------------------------------------------------------------------------------------------------------------------

select
	ltrim(left(cpg.cpg_credor,patindex('% %', cpg.cpg_credor))) as cpg_imposto,
	ltrim(replace(cpg.cpg_credor,ltrim(left(cpg.cpg_credor,patindex('%-%', cpg.cpg_credor))), '' )) as cpg_empresa,
	cpg.cpg_gcc_cod,gcc.gcc_descr,cpg.cpg_credor,cpg.cpg_doc,ipg.ipg_valor,ipg.ipg_valor_complemento,
	ipg.ipg_valor_cpg_desc,ipg.ipg_valor_cpg_desp_ac,ipg.ipg_valor_multa,
	ipg.ipg_dt_pgto,cpg.cpg_serie,cpg.cpg_num,ipg.ipg_status,cpg.cpg_fis_jur,
	ipg.ipg_bcp_serie,ipg.ipg_bcp_num,bcp.bcp_dthr,bcp.bcp_tipo_pag,
	cpg.cpg_dt_doc_emiss,convert(varchar,ipg.ipg_dt_vcto,103) as ipg_dt_vcto
from 
	ipg,cpg,bcp,gcc  
where (cpg.cpg_serie = ipg.ipg_cpg_serie) 
	and (cpg.cpg_num = ipg.ipg_cpg_num) 
	and (gcc.gcc_cod = cpg.cpg_gcc_cod)
	AND ((ipg.ipg_status in ('P') ) or ('0' in ('P')))
	and (ipg.ipg_dt_vcto >= '11-1-2019 0:0:0.000') 
	and (ipg.ipg_dt_vcto <= '12-27-2019 23:59:59.000') 
	and (cpg.cpg_tipo_compromisso like 'I') 
	and (cpg.cpg_gcc_cod like '10' or (ipg.ipg_gcc_cod_colig = '10'))
	and cpg.cpg_fis_jur = 'J'
order by
	LTRIM(left(cpg.cpg_credor,patindex('% %', cpg.cpg_credor))),gcc.gcc_descr,ipg.ipg_dt_vcto
------------------------------------------------------------------------------------------------------------------------------------------
/*
SELECT ltrim(left(cpg.cpg_credor, patindex('% %', cpg.cpg_credor))) AS cpg_imposto,
    ltrim(replace(cpg.cpg_credor, ltrim(left(cpg.cpg_credor, patindex('%-%', cpg.cpg_credor))), '')) AS cpg_empresa,
    cpg.cpg_gcc_cod,
    gcc.gcc_descr,
    cpg.cpg_credor,
    cpg.cpg_doc,
    ipg.ipg_valor,
    ipg.ipg_valor_complemento,
    ipg.ipg_valor_cpg_desc,
    ipg.ipg_valor_cpg_desp_ac,
    ipg.ipg_valor_multa,
    ipg.ipg_dt_pgto,
    cpg.cpg_serie,
    cpg.cpg_num,
    ipg.ipg_status,
    cpg.cpg_fis_jur,
    ipg.ipg_bcp_serie,
    ipg.ipg_bcp_num,    
    cpg.cpg_dt_doc_emiss,
    convert(VARCHAR, ipg.ipg_dt_vcto, 103) AS ipg_dt_vcto
FROM ipg,
    cpg,
    bcp,
    gcc
WHERE (cpg.cpg_serie = ipg.ipg_cpg_serie)
    AND (cpg.cpg_num = ipg.ipg_cpg_num)
    AND (gcc.gcc_cod = cpg.cpg_gcc_cod)
    AND ((ipg.ipg_status IN (:STATUS)) OR ('0' IN (:STATUS)))
    AND (ipg.ipg_dt_vcto >= :DATA_INICIAL)
    AND (ipg.ipg_dt_vcto <= :DATA_FINAL)
    AND (cpg.cpg_tipo_compromisso LIKE 'I')
    AND (cpg.cpg_gcc_cod LIKE :EMPRESA OR (ipg.ipg_gcc_cod_colig = :EMPRESA))
    AND ((ltrim(left(cpg.cpg_credor, patindex('% %', cpg.cpg_credor))) IN (:IMPOSTO)) OR ('0' IN (:IMPOSTO)))
    AND cpg.cpg_fis_jur = :PESSOA
ORDER BY LTRIM(left(cpg.cpg_credor, patindex('% %', cpg.cpg_credor))),
    gcc.gcc_descr,
    ipg.ipg_dt_vcto*/
------------------------------------------------------------------------------------------------------------------------------------------

/*
select * from day_imp

SELECT 'INSERT INTO day_imp (day_imp) VALUES (''' + day_imp + + ''')' FROM DAY_IMP

sp_help smartdb.dbo.day_imp
*/
------------------------------------------------------------------------------------------------------------------------------------------
/*
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[day_imp](
	[day_imp] [varchar](50) NOT NULL,
 CONSTRAINT [PK_day_imp] PRIMARY KEY CLUSTERED 
(
	[day_imp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

SELECT * FROM DAY_IMP

INSERT INTO day_imp (day_imp) VALUES ('COFINS')
INSERT INTO day_imp (day_imp) VALUES ('CSLL')
INSERT INTO day_imp (day_imp) VALUES ('FGTS')
INSERT INTO day_imp (day_imp) VALUES ('INSS')
INSERT INTO day_imp (day_imp) VALUES ('IPTU')
INSERT INTO day_imp (day_imp) VALUES ('IRPJ')
INSERT INTO day_imp (day_imp) VALUES ('IRRF')
INSERT INTO day_imp (day_imp) VALUES ('ISS')
INSERT INTO day_imp (day_imp) VALUES ('PCC')
INSERT INTO day_imp (day_imp) VALUES ('PIS')

ALTER DATABASE SCOPED CONFIGURATION SET DISABLE_BATCH_MODE_ADAPTIVE_JOINS = OFF;
*/