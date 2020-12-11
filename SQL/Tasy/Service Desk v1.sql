drop view TASY.UNIMED_INDICADOR_OS_TI;

create or replace view TASY.UNIMED_INDICADOR_OS_TI
as
select x.nr_sequencia,
       x.nr_seq_wheb,
       max(x.DS_DANO_BREVE) DS_DANO_BREVE,
       case 
            when nvl(round(x.dt_fim_real - nvl(x.dt_inicio_real, x.dt_fim_real)),0) < 5 
              then '1: Até 5 dias'
            when nvl(round(x.dt_fim_real - nvl(x.dt_inicio_real, x.dt_fim_real)),0) BETWEEN 6 and 15  
              then '2: Até 15 dias'
            when nvl(round(x.dt_fim_real - nvl(x.dt_inicio_real, x.dt_fim_real)),0) BETWEEN 16 and 25  
              then '3: Até 25 dias'
            when nvl(round(x.dt_fim_real - nvl(x.dt_inicio_real, x.dt_fim_real)),0) BETWEEN 26 and 45 
              then '4: Até 45 dias'
            when nvl(round(x.dt_fim_real - nvl(x.dt_inicio_real, x.dt_fim_real)),0) > 25 
              then '5: Acima de 45 dias'
            else '6: Não finalizado'
       end ds_dia_exec,
       case 
          when nvl(round(nvl(x.dt_fim_real,sysdate) - nvl(max(x.dt_fim_previsto), x.dt_fim_real)),0) < 5 
            then '1: Até 5 dias'
          when nvl(round(nvl(x.dt_fim_real,sysdate) - nvl(max(x.dt_fim_previsto), x.dt_fim_real)),0) BETWEEN 6 and 15  
            then '2: Até 15 dias'
          when nvl(round(nvl(x.dt_fim_real,sysdate) - nvl(max(x.dt_fim_previsto), x.dt_fim_real)),0) BETWEEN 16 and 25  
            then '3: Até 25 dias'
          when nvl(round(nvl(x.dt_fim_real,sysdate) - nvl(max(x.dt_fim_previsto), x.dt_fim_real)),0) BETWEEN 26 and 45 
            then '4: Até 45 dias'
          when nvl(round(nvl(x.dt_fim_real,sysdate) - nvl(max(x.dt_fim_previsto), x.dt_fim_real)),0) > 45 
            then '5: Acima de 45 dias'  
          else '6: Não finalizado'
       end ds_dia_atraso,
       --nvl(round(x.dt_fim_real - nvl(max(x.dt_fim_previsto), x.dt_fim_real)),0) qt_dia_atraso,
       --obter_min_entre_datas(dt_ordem_servico, max(x.dt_inicio_real), 1)/60 qt_min_prim_atend,
       --OBTER_HORA_ENTRE_DATAS(dt_ordem_servico, max(x.dt_inicio_real)) qt_horas_prim_atend,
       
       (select SUM(man_obter_tempo_estagio(w.nr_sequencia, x.nr_sequencia,'MC')) 
       	from MAN_ORDEM_SERV_ESTAGIO w
       	where w.NR_SEQ_ORDEM = x.nr_Sequencia
       	and w.NR_SEQ_ESTAGIO = '82') qt_min_prim_atend,
       	
       ((select SUM(man_obter_tempo_estagio(w.nr_sequencia, x.nr_sequencia,'MC')) 
       	from MAN_ORDEM_SERV_ESTAGIO w
       	where w.NR_SEQ_ORDEM = x.nr_Sequencia
       	and w.NR_SEQ_ESTAGIO = '82')/60) qt_horas_prim_atend,
       	
       	
       
       (select	sum(w.qt_minuto)
       from  	Man_Ordem_Serv_Ativ w
       where 	w.nr_seq_ordem_serv		= x.nr_sequencia) qt_min_ativ_os,
       (select	dividir(sum(w.qt_minuto),60)
       from  	Man_Ordem_Serv_Ativ w
       where 	w.nr_seq_ordem_serv		= x.nr_sequencia) qt_horas_ativ_os,
       
       OBTER_DIA_SEMANA(NVL(x.dt_fim_real,SYSDATE)) ds_dia_semana,
       max(x.IE_PRIORIDADE) IE_PRIORIDADE,
       substr(obter_valor_dominio(1046,max(x.IE_PRIORIDADE)),1,200) DS_PRIORIDADE,
       max(x.IE_PARADO) IE_PARADO,
       decode(max(x.IE_PARADO),'S','Sim','N','Não','P','Parcialmente') DS_PARADO,
       max(x.nr_seq_localizacao) nr_seq_localizacao,
       max(l.DS_LOCALIZACAO) DS_LOCALIZACAO,
       substr(obter_valor_dominio(1149, x.ie_classificacao), 1, 20) ds_classificacao,
       max(x.NR_SEQ_CLASSIF) NR_SEQ_CLASSIF, 
       OBTER_DESC_CLASSIFICACAO(max(x.NR_SEQ_CLASSIF)) ds_sub_classificacao,
       x.dt_ordem_servico,
       x.dt_ordem_servico DT_PARAMETRO,
       x.dt_inicio_real,
       x.dt_fim_real,
       nvl(trunc(x.dt_fim_real,'MM'),trunc(x.dt_ordem_servico,'MM')) dt_visao_periodo,
       max(x.CD_PESSOA_SOLICITANTE) CD_PESSOA_SOLICITANTE,
       max(f.CD_PESSOA_FISICA) cd_pessoa_fisica,
       substr(nvl(f.ds_apelido, f.nm_pessoa_fisica), 1, 60) nm_solicitante,
       max(x.nr_seq_equipamento) nr_seq_equipamento,
       substr(man_obter_desc_equip_os_par(x.nr_seq_equipamento), 1, 255) ds_equipamento,
       max(s.CD_SETOR_ATENDIMENTO) CD_SETOR_ATENDIMENTO,
       
       max(nvl(OBTER_CENTRO_CUSTO_SETOR(s.CD_SETOR_ATENDIMENTO,'C'),'***Não Informado')) cd_centro_custo,
       max(nvl(OBTER_CENTRO_CUSTO_SETOR(s.CD_SETOR_ATENDIMENTO,'DS'),'***Não Informado')) ds_centro_custo,
       
       max(l.CD_CENTRO_CUSTO) cd_centro_custo_localiz,
       max(OBTER_DESC_CENTRO_CUSTO(l.CD_CENTRO_CUSTO)) ds_centro_custo_localiz,
       
       substr(nvl(man_obter_dados_solicitante(MAX(x.CD_PESSOA_SOLICITANTE),'CC'),'***Não Informado'),1,255) cd_centro_cus_solic,
       substr(nvl(man_obter_dados_solicitante(MAX(x.CD_PESSOA_SOLICITANTE),'DCC'),'***Não Informado'),1,255) ds_centro_cus_solic,
       
       s.ds_setor_atendimento,
       max(l.CD_ESTABELECIMENTO) CD_ESTABELECIMENTO,
       initcap(substr(obter_nome_estabelecimento(l.cd_estabelecimento), 1, 255)) ds_estab_localiz,
       x.NR_GRUPO_TRABALHO,
       t.ds_grupo_trabalho,
       x.ie_status_ordem,
       decode(x.ie_status_ordem, 1, 'Aberta', 2, 'Processo', 'Encerrado') ds_status_ordem,
       p.nr_sequencia cd_estagio,
       p.ds_estagio,
       nvl(u.ds_usuario,'***Não Informado') ds_usuario_exec,
       nvl(i.ds_complexidade,'***Não Informado') ds_complexidade,
       x.ie_classificacao,
       substr(obter_valor_dominio(1197, x.ie_grau_satisfacao), 1, 100) ds_grau_satisfacao,
       max(x.cd_funcao) CD_FUNCAO,
       f.ds_funcao,
       max(x.NR_GRUPO_PLANEJ) NR_GRUPO_PLANEJ,
       max(g.DS_GRUPO_PLANEJ) DS_GRUPO_PLANEJAMENTO,
       count(*) QT_TOTAL,
       --case when trunc(x.dt_ordem_servico,'MM') = nvl(trunc(x.dt_fim_real,'MM'),trunc(x.dt_ordem_servico,'MM')) and x.ie_status_ordem <> 3 then 1 else 0 end Qtd_pendente,
       case when x.ie_status_ordem <> 3 then 1 else 0 end Qtd_pendente,
       
       case when trunc(x.dt_ordem_servico,'MM') = nvl(trunc(x.dt_fim_real,'MM'),trunc(x.dt_ordem_servico,'MM')) and x.ie_status_ordem = 3 then 1 else 0 end QT_ENCERRADA,
       case when trunc(x.dt_ordem_servico,'MM') = trunc(x.dt_ordem_servico,'MM') and x.ie_status_ordem = 3 then 1 else 0 end QT_ENCERRADA_COMP,
       
       
       case when trunc(x.dt_ordem_servico,'MM') <> trunc(x.dt_fim_real,'MM') then 1 else 0 end ie_comp_anterior,
       case when trunc(x.dt_ordem_servico,'MM') <> trunc(x.dt_fim_real,'MM') and x.ie_status_ordem <> 3 then 1 else 0 end ie_comp_anterior_pend,
       case when trunc(x.dt_ordem_servico,'MM') <> trunc(x.dt_fim_real,'MM') and x.ie_status_ordem = 3  then 1 else 0 end ie_comp_anterior_enc,
       
       (case when trunc(x.dt_ordem_servico,'MM') = nvl(trunc(x.dt_fim_real,'MM'),trunc(x.dt_ordem_servico,'MM')) and x.ie_status_ordem = 3 then 1 else 0 end
       +
       case when trunc(x.dt_ordem_servico,'MM') < trunc(x.dt_fim_real,'MM') and x.ie_status_ordem = 3  then 1 else 0 end ) qtd_total_encerradas,
       
       CASE 
       	  WHEN UPPER(t.ds_grupo_trabalho) LIKE UPPER('TI%INFRA%') and x.NR_GRUPO_TRABALHO <> '864'
       	    THEN 'INFRA' 
       	  WHEN x.NR_GRUPO_TRABALHO = '864' 
       	  	THEN 'SOBREAVISO'
       	  ELSE 'APLICAÇÕES' 
       END DS_CATEGORIA_GRUPO,
       null nenhum
  from funcao                f,
       usuario               u,
       man_causa_dano        k,
       man_tipo_solucao      y,
       setor_atendimento     s,
       grupo_suporte         o,
       gpi_projeto           w,
       gpi_cron_etapa        v,
       pessoa_fisica         f,
       grupo_desenvolvimento d,
       man_complexidade      i,
       man_classificacao     c,
       man_grupo_trabalho    t,
       man_grupo_planejamento    g,
       man_catalogo_servico  z,
       man_estagio_processo  p,
       man_equipamento       e,
       man_localizacao       l,
       man_ordem_servico     x,
       PROJETO_TASY          pt
where x.cd_pessoa_solicitante = f.cd_pessoa_fisica
   and s.cd_setor_atendimento = l.cd_setor
   and x.nr_seq_equipamento = e.nr_sequencia
   and x.nr_seq_localizacao = l.nr_sequencia
   and x.cd_funcao = f.cd_funcao(+)
   and x.nr_seq_proj_gpi = w.nr_sequencia(+)
   and x.nr_seq_etapa_gpi = v.nr_sequencia(+)
   and x.nm_usuario_exec = u.nm_usuario(+)
   and x.nr_seq_estagio = p.nr_sequencia(+)
   and x.nr_grupo_trabalho = t.nr_sequencia(+)
   and x.nr_grupo_planej = g.nr_sequencia(+)
   and x.nr_seq_grupo_sup = o.nr_sequencia(+)
   and x.nr_seq_grupo_des = d.nr_sequencia(+)
   and x.nr_seq_classif = c.nr_sequencia(+)
   and x.nr_seq_complex = i.nr_sequencia(+)
   and x.nr_seq_causa_dano = k.nr_sequencia(+)
   and x.nr_seq_tipo_solucao = y.nr_sequencia(+)
   and x.nr_seq_cs = z.nr_sequencia(+)
   and x.nr_seq_projeto = pt.nr_sequencia(+)
   
   --AND UPPER(t.ds_grupo_trabalho) LIKE UPPER('TI%')

   --and nvl(trunc(x.dt_fim_real,'MM'),trunc(x.dt_ordem_servico,'MM')) = '01/07/2015'
   --and trunc(x.DT_ORDEM_SERVICO,'MM') = '01/07/2015'
   and x.NR_GRUPO_PLANEJ = 1625 -- Grupo de planejamento SUPORTE TI
   --and x.ie_status_ordem = 3
 
   
   group by
       x.nr_sequencia,
       x.nr_seq_wheb,
       substr(obter_valor_dominio(1149, x.ie_classificacao), 1, 20),
       x.dt_ordem_servico,
       x.dt_inicio_real,
       x.dt_fim_real,
       substr(nvl(f.ds_apelido, f.nm_pessoa_fisica), 1, 60),
       substr(man_obter_desc_equip_os_par(x.nr_seq_equipamento), 1, 255),
       s.ds_setor_atendimento,
       substr(obter_nome_estabelecimento(l.cd_estabelecimento), 1, 255) ,
       t.ds_grupo_trabalho,
       decode(x.ie_status_ordem, 1, 'Aberta', 2, 'Processo', 'Encerrado') ,
       p.ds_estagio,
       u.ds_usuario,
       i.ds_complexidade,
       x.ie_classificacao,
       substr(obter_valor_dominio(1197, x.ie_grau_satisfacao), 1, 100),
       f.ds_funcao,
       x.NR_GRUPO_TRABALHO,
       ie_status_ordem,
       p.nr_sequencia;

