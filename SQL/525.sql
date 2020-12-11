select 
p.dt_procedimento dt_procedimento,
substr(p.nr_atendimento,1,255) nr_atendimento,
to_char(b.dt_entrada, 'dd/mm/yyyy') dt_atendimento,
to_char(b.dt_entrada, 'hh24:mi:ss') hr_atendimento,
p.nr_interno_conta nr_interno_conta,
c.cd_convenio_parametro cd_convenio,
obter_nome_convenio(c.cd_convenio_parametro) convenio,
obter_pessoa_atendimento(p.nr_atendimento, 'N') paciente,
obter_nome_pf(p.cd_medico_executor) medico,
obter_nome_pf(at.cd_medico_atendimento) as medico_atendimento,
obter_nome_pf(at.cd_medico_resp) as medico_responsavel,
substr(obter_nome_usuario(p.cd_medico_req),1,255) medico_cpoe,
substr(obter_nome_setor(obter_setor_atendimento(p.nr_atendimento)),1,255) setor,
substr(decode(p.ie_tiss_tipo_guia,7,'M','P'),1,255) identificador,
substr(p.cd_procedimento,1,255) cd_procedimento,
substr(obter_desc_procedimento(p.cd_procedimento, p.ie_origem_proced),1,255) procedimento,
substr(p.qt_procedimento,1,255) qt_procedimento,
substr(p.vl_medico,1,255)as vl_medico,
p.vl_procedimento vl_procedimento,
substr(obter_valor_conta(p.nr_interno_conta,0),1,255) vl_conta,
substr((select v.ds_valor_dominio from valor_dominio v where v.cd_dominio = 49 and v.vl_dominio =  obter_status_conta(p.nr_interno_conta,'C')),1,255) status_conta,
substr(obter_nome_estab(obter_estab_atendimento(p.nr_atendimento)),1,255) estab,
c.nr_protocolo, b.cd_procedencia,
obter_desc_procedencia(b.cd_procedencia) procedencia
from procedimento_paciente p, procedimento a, atendimento_paciente b, conta_paciente c, atendimento_paciente at
where ((a.cd_procedimento = p.cd_procedimento) and (a.ie_origem_proced = p.ie_origem_proced))
and    b.nr_atendimento = p.nr_atendimento
and b.nr_atendimento = at.nr_atendimento
and p.nr_interno_conta = c.nr_interno_conta (+)
and p.cd_motivo_exc_conta is null
and c.ie_cancelamento is null
and p.dt_procedimento between inicio_dia(:dt_inicial) and fim_dia(:dt_final)
and c.nr_interno_conta is not null
and obter_area_procedimento(a.cd_procedimento, a.ie_origem_proced) <> 10
and p.vl_procedimento > 0 
and obter_se_atend_retorno(p.nr_atendimento) <> 'S'
union all
select m.dt_atendimento dt_procedimento,
substr(m.nr_atendimento,1,255) nr_atendimento,
to_char(d.dt_entrada, 'dd/mm/yyyy') dt_atendimento,
to_char(d.dt_entrada, 'hh24:mi:ss') hr_atendimento,
m.nr_interno_conta nr_interno_conta,
c.cd_convenio_parametro cd_convenio,
obter_nome_convenio(c.cd_convenio_parametro) convenio,
obter_pessoa_atendimento(m.nr_atendimento, 'N') paciente,
(select obter_nome_pf(x.cd_medico_cirurgiao) from cirurgia x where x.nr_cirurgia = m.nr_cirurgia) medico_exec,
obter_nome_pf(at.cd_medico_atendimento) as medico_atendimento,
obter_nome_pf(at.cd_medico_resp) as medico_responsavel,
' 'as medico_cpoe,
substr(obter_nome_setor(obter_setor_atendimento(m.nr_atendimento)),1,255) setor,
substr('M',1,255) identificador,
substr(m.cd_material,1,255) cd_procedimento,
substr(obter_desc_material(m.cd_material),1,255) procedimento,
substr(m.qt_material,1,255) qt_procedimento,
' ' vl_medico,
m.vl_material vl_procedimento,
substr(obter_valor_conta(c.nr_interno_conta,0),1,255) vl_conta,
substr((select v.ds_valor_dominio from valor_dominio v where v.cd_dominio = 49 and v.vl_dominio =  obter_status_conta(c.nr_interno_conta,'C')),1,255) status_conta,
substr(obter_nome_estab(obter_estab_atendimento(m.nr_atendimento)),1,255) estab,
c.nr_protocolo, d.cd_procedencia,
obter_desc_procedencia(d.cd_procedencia) procedencia
from material_atend_paciente m,
atendimento_paciente d, conta_paciente c, atendimento_paciente at
where d.nr_atendimento = m.nr_atendimento
and d.nr_atendimento = at.nr_atendimento
and m.nr_interno_conta = c.nr_interno_conta (+)
and m.cd_motivo_exc_conta is null
and c.ie_cancelamento is null
and m.dt_atendimento between inicio_dia(:dt_inicial) and fim_dia(:dt_final)
and c.nr_interno_conta is not null
and m.vl_material > 0
and obter_se_atend_retorno(m.nr_atendimento) <> 'S'
order by 1,2,3