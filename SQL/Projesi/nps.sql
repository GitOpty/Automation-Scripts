--------------------------------------------------------
------------------ SEQUENCE ----------------------------
--------------------------------------------------------

CREATE SEQUENCE PROJESIWDS_NPS_SEQ INCREMENT BY 1 MAXVALUE 9999999999 MINVALUE 1 CYCLE NOCACHE;
/
--------------------------------------------------------
------------------ TABLE -------------------------------
--------------------------------------------------------

CREATE TABLE PROJESIWDS_NPS 
(
  ID NUMBER NOT NULL 
, PRONTUARIO NUMBER NOT NULL 
, CELULAR VARCHAR2(20 BYTE) NOT NULL 
, NOMEPACIENTE VARCHAR2(120 BYTE) NOT NULL 
, SOBRENOMEPACIENTE VARCHAR2(50 BYTE) NOT NULL 
, CONVENIOPACIENTE VARCHAR2(100 BYTE) 
, PLANOPACIENTE VARCHAR2(100 BYTE)
, DATANASCIMENTO DATE 
, DATACOMPROMISSO DATE NOT NULL 
, MEDICO VARCHAR2(50 BYTE) 
, DATAHORAGERADO DATE DEFAULT SYSTIMESTAMP NOT NULL 
, DATAHORAENVIO DATE 
, TEXTOMSGENVIADA VARCHAR2(160 BYTE) 
, NOTA NUMBER 
, TEXTORESPOSTA VARCHAR2(250 BYTE) 
, DATAHORARESPOSTA DATE 
, NOMEUNIDADE VARCHAR2(200 BYTE)
, EMPRESA NUMBER NOT NULL
, CONSTRAINT NPS_PK PRIMARY KEY 
  (
    PRONTUARIO 
  , CELULAR 
  , DATACOMPROMISSO 
  , NOMEUNIDADE
  , EMPRESA
  )
  ENABLE 
);
/
--------------------------------------------------------
------------------ VIEWS -------------------------------
--------------------------------------------------------
 create or replace view PROJESIWDS_UNIDADES AS 
  SELECT A.CD_ESTABELECIMENTO
    ,A.NM_FANTASIA_ESTAB AS DS_FANTASIA
    ,A.CD_EMPRESA
    ,A.IE_SITUACAO
FROM pessoa_juridica p
INNER JOIN Estabelecimento a ON(a.cd_cgc = p.cd_cgc)
where cd_estabelecimento != 3
ORDER BY cd_estabelecimento;


---------------------------------------------------
---------------------------------------------------

 create or replace view PROJESIWDS_EMPRESAS AS 
  SELECT E.CD_EMPRESA
    ,E.NM_RAZAO_SOCIAL
FROM empresa e
ORDER BY e.NM_RAZAO_SOCIAL;

---------------------------------------------------
---------------------------------------------------

  CREATE OR REPLACE VIEW PROJESIWDS_AGENDAPORMEDICO1 As
  select
c.nr_atendimento,
c.nr_sequencia as id_compromisso,
c.cd_agenda,
c.dt_agenda as data,
to_char(c.hr_inicio, 'hh24:mi:ss') as HI,
c.nr_minuto_duracao as duracao,
obter_medico_agecons(c.cd_agenda, 'C') as ID_Profissional,
c.cd_medico,
to_char(cd_procedimento) as ID_procedimento,
c.cd_pessoa_fisica IDCliente,
c.cd_pessoa_fisica,
obter_nome_pf(c.cd_pessoa_fisica) as NomeCliente,
c.cd_usuario_convenio,
pf.nr_ddd_celular as DDDFone,
pf.nr_telefone_celular as FoneCliente,
pf.dt_nascimento as DtNasc,
c.ie_status_agenda,
to_char(c.nr_seq_classif_agenda) as classif_agenda,
'' ds_classificacao,
obter_valor_dominio(83,c.ie_status_agenda) as status_agenda,
c.cd_convenio,
c.cd_plano,
decode(obter_tipo_agenda(c.cd_agenda),1,'Cirurgias',2,'Exames') as indicativo,
obter_classif_atendimento(c.nr_atendimento) as classif_atendimento,
c.cd_categoria,
c.cd_tipo_acomodacao,
---------c.cd_setor_atendimento,
a.cd_setor_exclusivo,
c.dt_validade_carteira,
substr(obter_classif_tasy_agecons(c.nr_seq_classif_agenda),1,15) CD_CLASSIF_TASY,
c.dt_agendamento
from agenda_paciente c,
agenda a,
pessoa_fisica pf
where c.cd_pessoa_fisica = pf.cd_pessoa_fisica
and c.cd_agenda = a.cd_agenda
and trunc(c.dt_agenda) >= trunc(sysdate)-365;


------------------------------------------------------------------------
------------------------------------------------------------------------

CREATE OR REPLACE VIEW PROJESIWDS_CLIENTES1
AS   select
pf.cd_pessoa_fisica as prontuario,
pf.nm_pessoa_fisica as nome,
pf.nm_pessoa_fisica as sobrenome,
cpf.ds_email as email,
pf.nr_ddd_celular as DDDCelular,
pf.nr_telefone_celular as celular,
pf.dt_nascimento as dt_nasc,
pf.nr_identidade,
pf.nr_cpf,
obter_nome_mae_pf(pf.cd_pessoa_fisica) nome_mae,
pf.dt_atualizacao,
pf.ie_sexo,
cpf.cd_cep,
cpf.ds_endereco,
cpf.nr_telefone as nr_telefone_residencial,
(select k.nr_ddd_telefone || k.nr_telefone from compl_pessoa_fisica k where k.cd_pessoa_fisica = pf.cd_pessoa_fisica and k.ie_tipo_complemento = 2) nr_telefone_comercial,
cpf.ds_complemento,
cpf.nr_endereco,
cpf.cd_profissao,
pf.nr_cartao_nac_sus_ant as cns
from pessoa_fisica pf,
     compl_pessoa_fisica cpf
where pf.cd_pessoa_fisica = cpf.cd_pessoa_fisica
      and cpf.ie_tipo_complemento = 1;

------------------------------------------------------------------------
------------------------------------------------------------------------

CREATE OR REPLACE VIEW PROJESIWDS_PROCEDIMENTOS1
AS   select p.cd_procedimento as id_procedimento,
p.ds_procedimento as procedimento,
p.ds_orientacao
from procedimento p
where p.ie_situacao = 'A';

------------------------------------------------------------------------
------------------------------------------------------------------------

CREATE OR REPLACE VIEW PROJESIWDS_CONVENIOS
AS   select c.cd_convenio as id,
c.ds_convenio as,
c.ie_tipo_convenio
from convenio c
where c.ie_situacao = 'A'
order by 1;

------------------------------------------------------------------------
------------------------------------------------------------------------

CREATE VIEW PROJESIWDS_CONVENIO_PLANO
AS SELECT CD_CONVENIO 
, CD_PLANO   
, DS_PLANO  
, IE_SITUACAO  
, DT_ATUALIZACAO 
FROM CONVENIO_PLANO;

------------------------------------------------------------------------
------------------------------------------------------------------------

CREATE OR REPLACE VIEW PROJESIWDS_MEDICOS1
AS select a.cd_agenda,
a.cd_pessoa_fisica as id_profissional,
a.ds_agenda,
obter_nome_pf(a.cd_pessoa_fisica) as nome,
obter_crm_medico(a.cd_pessoa_fisica) crm,
obter_dados_medico(a.cd_pessoa_fisica,'UFCRM') ufcrm,
pf.nr_seq_cbo_saude as cbo
,A.cd_estabelecimento
,pf.IE_SEXO as genero
from agenda a,
pessoa_fisica pf
where a.cd_pessoa_fisica = pf.cd_pessoa_fisica
and a.ie_situacao = 'A';

--------------------------------------------------------
------------------ PROCEDURES --------------------------
--------------------------------------------------------

create or replace PROCEDURE CONFIRMA_ADDNPS (
p_Data date,
p_ID number DEFAULT 0,
p_empresa number) AS
BEGIN

IF p_ID > 0 THEN
execute immediate 'DROP SEQUENCE PROJESIWDS_NPS_SEQ';
COMMIT;

execute immediate 'CREATE SEQUENCE PROJESIWDS_NPS_SEQ INCREMENT BY 1 MAXVALUE 9999999999 MINVALUE ' || to_char(p_ID+1) || ' CYCLE NOCACHE';
COMMIT;
END IF;



INSERT INTO PROJESIWDS_NPS(ID, PRONTUARIO, NOMEPACIENTE, SOBRENOMEPACIENTE, DATANASCIMENTO, CONVENIOPACIENTE, PLANOPACIENTE, DATACOMPROMISSO, CELULAR, NOMEUNIDADE, MEDICO, EMPRESA)

SELECT PROJESIWDS_NPS_SEQ.NEXTVAL, TB.*
FROM (

WITH DATA AS
(
SELECT
    AM.IDCLIENTE,
    REPLACE(C.NOME, SUBSTR(C.SOBRENOME,instr(C.SOBRENOME,' ',-1)+1,LENGTH(C.SOBRENOME)), '') AS NOME,
   COALESCE(SUBSTR(trim(C.SOBRENOME),instr(trim(C.SOBRENOME),' ',-1)+1,LENGTH(trim(C.SOBRENOME))), '') AS SOBRENOME,
   C.DT_NASC AS DATANASCIMENTO,
   CONV.ID,
   CONV.DS_CONVENIO AS CONVENIO,
   PLANO.DS_PLANO AS PLANO,
    TRUNC(AM.DATA) AS DATACOMPROMISSO,
    '55' || substr(C.DDDCELULAR, -2) || substr(replace(replace(replace(replace(C.CELULAR, '(', ''), ')', ''), ' ', ''), '-', ''), -9) AS CELULAR,
    M.NOME AS MEDICO,
     (CASE WHEN UPPER(u.ds_fantasia) LIKE '%CEI%' THEN 'HOB Helio Prates'
                                          ELSE u.ds_fantasia END ) as unidade,
    u.cd_empresa AS EMPRESA,
    AM.HI

FROM    PROJESIWDS_AGENDAPORMEDICO1 AM
    inner JOIN PROJESIWDS_CLIENTES1 C ON
      AM.IDCLIENTE = C.PRONTUARIO
    inner JOIN PROJESIWDS_CONVENIOS CONV ON
      AM.CD_CONVENIO = CONV.ID
    left join PROJESIWDS_CONVENIO_PLANO PLANO ON
      AM.CD_CONVENIO = PLANO.CD_CONVENIO AND
      AM.CD_PLANO = PLANO.CD_PLANO
    inner JOIN PROJESIWDS_MEDICOS1 M ON
      AM.CD_AGENDA = M.CD_AGENDA
    inner join PROJESIWDS_UNIDADES U ON
     M.cd_estabelecimento = U.cd_estabelecimento
     INNER JOIN PROJESIWDS_EMPRESAS E ON
     u.cd_empresa = e.cd_empresa

WHERE trunc(AM.DATA) = TRUNC(p_Data)
    AND C.DDDCELULAR IS NOT NULL
    AND length(replace(replace(replace(replace(replace(rtrim(C.CELULAR), '.', ''), ' ', ''), '-', ''), '(',''), ')','')) >= 9
    AND AM.IE_STATUS_AGENDA NOT IN ('C', 'N', 'F', 'I')
    AND e.cd_empresa = p_empresa
    AND AM.IDCLIENTE NOT IN
                          ( SELECT    PRONTUARIO
                            FROM    PROJESIWDS_NPS
                            WHERE   trunc(DATACOMPROMISSO) = TRUNC(p_Data) )

)

SELECT IDCLIENTE, NOME, COALESCE(SOBRENOME, ''), DATANASCIMENTO, MIN(CONVENIO), MIN(PLANO), DATACOMPROMISSO, substr(CELULAR,1,least(20,length(CELULAR))) AS CELULAR, UNIDADE, MIN(MEDICO) AS MEDICO, EMPRESA
FROM DATA
GROUP BY IDCLIENTE
        ,NOME
        ,COALESCE(SOBRENOME, '')
        ,DATANASCIMENTO
        ,DATACOMPROMISSO
        ,substr(CELULAR,1,least(20,length(CELULAR)))
        ,UNIDADE
        ,EMPRESA
) TB
;

END;


/

------------------------------------------------------------------------
------------------------------------------------------------------------

create or replace PROCEDURE CONFIRMA_NPSOUTBOX (p_empresa NUMBER, cur OUT SYS_REFCURSOR)
AS
BEGIN

OPEN cur FOR

SELECT   ID --sms
    ,DATACOMPROMISSO AS AppointmentDateTime --appointment
    ,MEDICO AS ProfessionalName
    ,NOMEUNIDADE AS UnitName
    ,CELULAR AS MobilePhone --patient
    ,PRONTUARIO AS PatientID
    ,NOMEPACIENTE AS Firstname
    ,SOBRENOMEPACIENTE AS Lastname
    ,DATANASCIMENTO AS Birthday
    ,CONVENIOPACIENTE AS Insurance
FROM PROJESIWDS_NPS
WHERE (DATAHORAENVIO IS NULL) AND (trunc(DataCompromisso) = trunc(SYSTIMESTAMP-2))
AND EMPRESA = p_empresa;

END;


/

------------------------------------------------------------------------
------------------------------------------------------------------------

create or replace PROCEDURE CONFIRMA_NPSOUTBOXDATE (p_Data DATE, p_empresa NUMBER, cur OUT SYS_REFCURSOR)
AS
BEGIN

OPEN cur FOR

SELECT   ID --sms
    ,DATACOMPROMISSO AS AppointmentDateTime --appointment
    ,MEDICO AS ProfessionalName
    ,NOMEUNIDADE AS UnitName
    ,CELULAR AS MobilePhone --patient
    ,PRONTUARIO AS PatientID
    ,NOMEPACIENTE AS Firstname
    ,SOBRENOMEPACIENTE AS Lastname
    ,DATANASCIMENTO AS Birthday
    ,CONVENIOPACIENTE AS Insurance
FROM PROJESIWDS_NPS
WHERE     (DATAHORAENVIO IS NULL) AND (trunc(DataCompromisso) = trunc(p_Data))
AND EMPRESA = p_empresa;

END;

/

------------------------------------------------------------------------
------------------------------------------------------------------------

create or replace PROCEDURE CONFIRMA_UPDATESENTNPS (
  p_ID int,
  SentText nvarchar2,
  p_empresa number
)

AS
BEGIN

UPDATE PROJESIWDS_NPS

SET
  DATAHORAENVIO = Systimestamp,
  TEXTOMSGENVIADA = SentText

WHERE ID = p_ID
AND DATAHORARESPOSTA IS NULL
AND EMPRESA = p_empresa;

END;


/
------------------------------------------------------------------------
------------------------------------------------------------------------

create or replace PROCEDURE UPDATENPSANSWERRECEIVED (
  p_ID nvarchar2,
  AnswerText nvarchar2,
  p_Score number,
  p_empresa number)

AS
BEGIN

UPDATE PROJESIWDS_NPS SET
DataHoraResposta=Systimestamp,
TEXTORESPOSTA=AnswerText,
NOTA=p_Score

WHERE ID = p_ID
and DATAHORAENVIO IS NOT NULL
AND DataHoraResposta IS NULL
AND EMPRESA = p_empresa;
END;


/
------------------------------------------------------------------------
------------------------------------------------------------------------

create or replace PROCEDURE UPDATENPSANSWERRECEIVEDDT (
  p_ID nvarchar2,
  AnswerText nvarchar2,
  p_Score number,
  datetimeAnswer date,
  p_empresa number)

AS
BEGIN

UPDATE PROJESIWDS_NPS SET
DataHoraResposta=datetimeAnswer,
TEXTORESPOSTA=AnswerText,
NOTA=p_Score

WHERE ID = p_ID
and DATAHORAENVIO IS NOT NULL
AND DataHoraResposta IS NULL
AND EMPRESA = p_empresa;
END;


/
