--Consulta para verificar as contas e as coligações
--select * from gcc_colig
EXECUTE DePara_ContaColigada_HOSL
/*
CREATE PROCEDURE DePara_ContaColigada_HOSL
AS
---------------------------------------------------------------------------------
 
update ipg
set IPG_GCC_COD_COLIG = '10' --Conta Pagante
where ipg.ipg_cpg_serie in (119, 120)
--and convert(varchar(10), IPG_DT_PGTO, 103) = convert(varchar(10), getdate(), 103)
and ipg.ipg_cpg_num =
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = '10') --Código de Origem

---------------------------------------------------------------------------------
 
update ipg
set IPG_GCC_COD_COLIG = '10' --Conta Pagante
where ipg.ipg_cpg_serie in (119, 120)
--and convert(varchar(10), IPG_DT_PGTO, 103) = convert(varchar(10), getdate(), 103)
and ipg.ipg_cpg_num =
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = '11') --Código de Origem 

---------------------------------------------------------------------------------
 
update ipg
set IPG_GCC_COD_COLIG = '10' --Conta Pagante
where ipg.ipg_cpg_serie in (119, 120)
--and convert(varchar(10), IPG_DT_PGTO, 103) = convert(varchar(10), getdate(), 103)
and ipg.ipg_cpg_num =
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = '191') --Código de Origem

---------------------------------------------------------------------------------
 
update ipg
set IPG_GCC_COD_COLIG = '10' --Conta Pagante
where ipg.ipg_cpg_serie in (119, 120)
--and convert(varchar(10), IPG_DT_PGTO, 103) = convert(varchar(10), getdate(), 103)
and ipg.ipg_cpg_num =
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = '73') --Código de Origem

---------------------------------------------------------------------------------
 
update ipg
set IPG_GCC_COD_COLIG = '10' --Conta Pagante
where ipg.ipg_cpg_serie in (119, 120)
--and convert(varchar(10), IPG_DT_PGTO, 103) = convert(varchar(10), getdate(), 103)
and ipg.ipg_cpg_num =
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = '910') --Código de Origem

---------------------------------------------------------------------------------
 
update ipg
set IPG_GCC_COD_COLIG = '10' --Conta Pagante
where ipg.ipg_cpg_serie in (119, 120)
--and convert(varchar(10), IPG_DT_PGTO, 103) = convert(varchar(10), getdate(), 103)
and ipg.ipg_cpg_num =
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = '991') --Código de Origem*/