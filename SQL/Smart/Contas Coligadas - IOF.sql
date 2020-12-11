--Consulta para verificar as contas e as coligações
--select * from gcc_colig
EXECUTE DePara_ContaColigada_IOF
---------------------------------------------------------------------------------
/*
CREATE PROCEDURE DePara_ContaColigada_IOF
AS
update ipg
set IPG_GCC_COD_COLIG = 'IOF' --Conta Pagante
where ipg.ipg_cpg_serie in (119, 120)
--and convert(varchar(10), IPG_DT_PGTO, 103) = convert(varchar(10), getdate(), 103)
and ipg.ipg_cpg_num =
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = 'IOF') --Código de Origem

---------------------------------------------------------------------------------
 
update ipg
set IPG_GCC_COD_COLIG = 'IOF' --Conta Pagante
where ipg.ipg_cpg_serie in (119, 120)
--and convert(varchar(10), IPG_DT_PGTO, 103) = convert(varchar(10), getdate(), 103)
and ipg.ipg_cpg_num =
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = 'MP') --Código de Origem

---------------------------------------------------------------------------------
 
update ipg
set IPG_GCC_COD_COLIG = 'IOF' --Conta Pagante
where ipg.ipg_cpg_serie in (119, 120)
--and convert(varchar(10), IPG_DT_PGTO, 103) = convert(varchar(10), getdate(), 103)
and ipg.ipg_cpg_num =
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = 'OND') --Código de Origem

------
/*
SELECT IPG_GCC_COD_COLIG
    
from ipg

WHERE ipg.ipg_cpg_serie in (119, 1119)
    and ipg_cpg_num = '4172'
    and ipg.ipg_cpg_num =
    (select cpg_num
    from cpg
    where cpg.cpg_serie = ipg_cpg_serie
    and cpg.cpg_num = ipg_cpg_num
    and cpg_gcc_cod = 'MP') --Código de Origem


update ipg
set IPG_GCC_COD_COLIG = 'IOF' --Conta Pagante
where ipg.ipg_cpg_serie in (119, 1119)
and convert(varchar(10), IPG_DT_PGTO, 103) = convert(varchar(10), getdate(), 103)
and ipg.ipg_cpg_num =
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = 'MP') --Código de Origem
*/