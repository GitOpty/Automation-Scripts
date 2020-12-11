select distinct  cp.dt_periodo_inicial as DT_ENTRADA
                ,cp.nr_atendimento as nr_atend
                ,cp.nr_interno_conta
                ,obter_pessoa_atendimento(pp.nr_atendimento, 'N') paciente
                ,pp.cd_medico_executor
                ,obter_nome_pf(pp.cd_medico_executor) as NM_MEDICO_EXECUTOR
                ,obter_valor_conta(cp.nr_interno_conta,0) as vl_conta
from        procedimento_paciente pp
            inner join conta_paciente cp on cp.nr_interno_conta = pp.nr_interno_conta
            left join atendimento_paciente ap on ap.nr_atendimento = cp.nr_atendimento
where       cp.dt_periodo_inicial between inicio_dia(:dt_inicial) and fim_dia(:dt_final)
            and ap.nm_usuario_atend = :nm_usuario

order by 1



select  ap.nm_usuario_atend as nm_usuario
from    atendimento_paciente ap
        left join conta_paciente cp on cp.nr_atendimento = ap.nr_atendimento
where   cp.dt_periodo_inicial between inicio_dia(:dt_inicial) and fim_dia(:dt_final)
group by ap.nm_usuario_atend
