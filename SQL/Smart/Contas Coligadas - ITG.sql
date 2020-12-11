EXECUTE DePara_ContaColigada_Itaigara
--drop procedure DePara_ContaColigada
--Consulta para verificar as contas e as coligações
--select * from gcc_colig
---------------------------------------------------------------------------------
/*
DECLARE @jobId BINARY(16);
-- Procedure que cria o job 
EXEC msdb.dbo.sp_add_job 
@job_name=N'JobContaColigada', -- Nome do job 
@job_id = @jobId OUTPUT -- O id do job será setado para variável @jobId, para ser utilizado nos demais passos
---------------------------------------------------------------------------------
-- Procedure que cria um passo do job 
EXEC msdb.dbo.sp_add_jobstep 
@job_id = @jobId, -- Id do job ao qual o passo será associado 
@step_name=N'Passo 1', -- Nome do passo do job 
@step_id=1, -- Número do passo do job 
@subsystem=N'TSQL', -- Tipo do passo que será executado, a opção TSQL é a mais comum (olhe no site da microsoft demais opções) 
@command=N'EXECUTE DePara_ContaColigada', 
@database_name=N'SMARTDB' -- Nome do banco de dados que o passo será chamado 
--&nbsp;
---------------------------------------------------------------------------------
-- Procedure que adicionar o intervalo do job
 
EXEC msdb.dbo.sp_add_jobschedule 
@job_id=@jobId, -- Id do job ao qual o passo será associado 
@name=N'Nome da tafera', --  Nome da tarefa 
@freq_type=4, -- Determina o intervalo de execução do job (1 = Uma vez, 4 = Diarimante, 8 = Semanalmente, 16 = Mensal, 32 = Mensal relacionado a frequencia, 64 = Executa quando o SQL Aegnte inicia e 128 = Executa quando o server está inativo)
@freq_interval=4, -- Determina o período a ser executado (1 = Quando a frequency_interval não é usado, 4 = Todos os dias, 8 = Semanal, 16 = Mensal, 32 = Mensal combinado com dia da semana, 64 = Executa quando o SQL Agenda é iniciado)
@freq_subday_type=4, -- Determina o tipo de intervalo (1 = Não definido, 4 = Minutos e 8 = Horas)
@freq_subday_interval=1, -- Determina o intervalo de execução entre cada job (1 = Não definido, 4 = Minutos e 8 = Horas)
@freq_relative_interval=0,
@freq_recurrence_factor=1, -- Quantidade de semanas ou meses entre a execução do job, somente é utilizado se o parametro frequency_type for: 8, 16 ou 32
@active_start_date=20100302, -- Data que o job irá iniciar, o padrão é 19900101 (YYYYMMDD)
@active_end_date=99991231, -- Data que o job irá parar, srguir o padrão YYYYMMDD
@active_start_time=60000, -- Intervalo active_start_date e active_end_date para iniciar a execução do job
@active_end_time=190000 -- Intervalo active_start_date e active_end_date para para a execução do job
*/
---------------------------------------------------------------------------------
/*
---------------------------------------------------------------------------------
CREATE PROCEDURE DePara_ContaColigada_Itaigara
AS


update ipg
set IPG_GCC_COD_COLIG = 'DHI' --Conta Pagante
where ipg.ipg_cpg_serie in (120, 1120, 119, 1119)
and ipg.ipg_cpg_num =
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = '1') --Código de Origem
 
---------------------------------------------------------------------------------
 
update ipg
set IPG_GCC_COD_COLIG = '4' --Conta Pagante
where ipg.ipg_cpg_serie in (120, 1120, 119, 1119)
and ipg.ipg_cpg_num = 
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = '16') --Código de Origem
 
---------------------------------------------------------------------------------
 
update ipg
set IPG_GCC_COD_COLIG = 'DHI' --Conta Pagante
where ipg.ipg_cpg_serie in (120, 1120, 119, 1119)
and ipg.ipg_cpg_num = 
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = '3') --Código de Origem
 
---------------------------------------------------------------------------------
 
update ipg
set IPG_GCC_COD_COLIG = '4' --Conta Pagante
where ipg.ipg_cpg_serie in (120, 1120, 119, 1119)
and ipg.ipg_cpg_num = 
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = '4') --Código de Origem
 
---------------------------------------------------------------------------------
 
update ipg
set IPG_GCC_COD_COLIG = 'DHI' --Conta Pagante
where ipg.ipg_cpg_serie in (120, 1120, 119, 1119)
and ipg.ipg_cpg_num = 
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = '9') --Código de Origem

---------------------------------------------------------------------------------

update ipg
set IPG_GCC_COD_COLIG = 'DHI' --Conta Pagante
where ipg.ipg_cpg_serie in (120, 1120, 119, 1119)
and ipg.ipg_cpg_num = 
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = 'DH4') --Código de Origem
 
---------------------------------------------------------------------------------
 
update ipg
set IPG_GCC_COD_COLIG = 'DHI' --Conta Pagante
where ipg.ipg_cpg_serie in (120, 1120, 119, 1119)
and ipg.ipg_cpg_num = 
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = 'DHI') --Código de Origem
*/
---------------------------------------------------------------------------------
/*
SELECT IPG_GCC_COD_COLIG = 'DHI' --Conta Pagante
    , ipg.ipg_cpg_serie
    , ipg.ipg_cpg_num
    , cpg.cpg_num

FROM ipg
    , cpg
WHERE ipg.ipg_cpg_serie in (119, 1119)
    and convert(varchar(10), IPG_DT_PGTO, 103) = convert(varchar(10), getdate(), 103)
    and ipg.ipg_cpg_num = 
        (select cpg_num
        from cpg
        where cpg.cpg_serie = ipg_cpg_serie
            and cpg.cpg_num = ipg_cpg_num
            and cpg_gcc_cod = 'DHI') --Código de Origem



SELECT IPG_GCC_COD_COLIG = 'DHI' --Conta Pagante
where ipg.ipg_cpg_serie in (119, 1119)
and convert(varchar(10), IPG_DT_PGTO, 103) = convert(varchar(10), getdate(), 103)
and ipg.ipg_cpg_num = 
(select cpg_num
from cpg
where cpg.cpg_serie = ipg_cpg_serie
and cpg.cpg_num = ipg_cpg_num
and cpg_gcc_cod = 'DHI') --Código de Origem
*/