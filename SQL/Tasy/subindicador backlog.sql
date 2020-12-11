drop view TASY.UNIMED_SUBINDICADOR_BACKLOG;

create or replace view TASY.UNIMED_SUBINDICADOR_BACKLOG
as
select cd,
       DS_ESTAB_LOCALIZ,
       sum("30d") "30d",
       sum("60d") "60d",
       sum("90d") "90d",
       sum("120d") "120d",
       sum("+180d") "+180d",
       sum(QTD_PENDENTE) QTD_PENDENTE
from (
select 0 cd, a.DS_ESTAB_LOCALIZ, 
round(trunc(sysdate,'MM') - trunc(a.dt_ordem_servico,'MM')),
case when round(trunc(sysdate,'MM') - trunc(a.dt_ordem_servico,'MM')) < 33 then 1 else 0 end "30d",
case when round(trunc(sysdate,'MM') - trunc(a.dt_ordem_servico,'MM')) BETWEEN 33 and 62 then 1 else 0 end "60d",
case when round(trunc(sysdate,'MM') - trunc(a.dt_ordem_servico,'MM')) BETWEEN 63 and 92 then 1 else 0 end "90d",
case when round(trunc(sysdate,'MM') - trunc(a.dt_ordem_servico,'MM')) BETWEEN 93 and 122 then 1 else 0 end "120d",
case when round(trunc(sysdate,'MM') - trunc(a.dt_ordem_servico,'MM')) > 122 then 1 else 0 end "+180d",
sum(a.QTD_PENDENTE) QTD_PENDENTE
from UNIMED_INDICADOR_OS_TI a
where 1 = 1
and a.IE_STATUS_ORDEM <> 3
and trunc(a.DT_ORDEM_SERVICO,'MM') <= add_months(trunc(sysdate,'MM'),-1)
group by a.DS_ESTAB_LOCALIZ, a.dt_ordem_servico
)
group by cd, DS_ESTAB_LOCALIZ;

