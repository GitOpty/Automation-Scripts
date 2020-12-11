EXECUTE DePara_ContaColigada_Oftalmoclin
/*
create PROCEDURE DePara_ContaColigada_Oftalmoclin
AS
update ipg
set IPG_GCC_COD_COLIG = '200' --Conta Pagante
where ipg.ipg_cpg_serie in (120, 119)
and ipg.ipg_cpg_num = 
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = '583') --Código de Origem

update ipg
set IPG_GCC_COD_COLIG = '200' --Conta Pagante
where ipg.ipg_cpg_serie in (120, 119)
and ipg.ipg_cpg_num = 
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = '200') --Código de Origem*/