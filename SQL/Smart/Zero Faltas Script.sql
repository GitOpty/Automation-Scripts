declare @dataI VARCHAR(10) = '2020-08-02'
 declare @dataF VARCHAR(10) = '2020-08-09'
 
select distinct
 a.ID_CLIENTE, a.TIPO_AGENDA_DESC
 into #expurgo
from Projesi_Zero_Faltas a
left join [Pacientes_Unidade] b on a.ID_CLIENTE = b.[CD_PESSOA_FISICA] and a.UNIDADE = b.[DS_UNIDADE]
 where a.datacompromisso between @dataI and @dataF
 and a.unidade in ('HOB Brasilia 01-66','INOB - Inob Instituto de Olhos e Microcirurgia','HOB Brasilia - Filial Taguatinga Sul - 04-09','HOB Brasilia - Filial Ceilândia 03-28','HOB Brasilia - Filial Sobradinho 09-13','HOG - Hospital de Olhos do Gama')
and a.TIPO_AGENDA_DESC not in ('Consultas')
 
 select distinct
 a.ID_COMPROMISSO,
 a.ID_CLIENTE,
 a.NOMEPACIENTE,
 DATANASCIMENTO = b.[DT_NASCIMENTO],
 a.CELULAR,
 a.EMAIL,
 ID_CONVENIO = '',
 a.CONVENIO,
 ID_PLANO = '',
 PLANO = '',
 a.DATACOMPROMISSO,
 a.HORACOMPROMISSO,
 a.ID_STATUS,
 a.DS_STATUS,
 ID_AGENDA = a.cd_agenda,
 a.AGENDA,
 ID_PROCEDIMENTO = a.cd_procedimento,
 a.PROCEDIMENTO,
 a.ID_EMPRESA,
 a.EMPRESA,
 a.ID_UNIDADE,
 a.UNIDADE
from Projesi_Zero_Faltas a
left join [Pacientes_Unidade] b on a.ID_CLIENTE = b.[CD_PESSOA_FISICA] and a.UNIDADE = b.[DS_UNIDADE]
 where a.datacompromisso between @dataI and @dataF
 and a.unidade in ('HOB Brasilia 01-66','INOB - Inob Instituto de Olhos e Microcirurgia','HOB Brasilia - Filial Taguatinga Sul - 04-09','HOB Brasilia - Filial Ceilândia 03-28','HOB Brasilia - Filial Sobradinho 09-13','HOG - Hospital de Olhos do Gama')
and a.TIPO_AGENDA_DESC in ('Consultas')
and isnull(a.autorizacao,'X')  in ('X','Autorizado','Não necessita autorização','Não necessita autorização','Não necessita autorização')
and a.DS_status not in ('Aguardando remarcação','Remarcar','Aguardando','Aguardando')
and ID_CLIENTE not in (Select b.ID_CLIENTE from #expurgo b)
and Procedimento like '%consulta%'
 
order by DATACOMPROMISSO desc, HORACOMPROMISSO
 
Drop table #expurgo
 
-- select distinct isnull(TIPO_AGENDA_DESC,'X')  from Projesi_Zero_Faltas
-- select distinct unidade, agenda  from Projesi_Zero_Faltas order by 1,2
-- select unidade, count (*) from Projesi_Zero_Faltas group by unidade order by 1,2