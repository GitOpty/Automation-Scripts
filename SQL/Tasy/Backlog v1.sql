drop view TASY.UNIMED_BACKLOG_V1;

create or replace view TASY.UNIMED_BACKLOG_V1
as
SELECT A.CD,
       A.DS_ESTAB_LOCALIZ, 
       A."30d", to_number(to_char(((A."30d"/QTD_PENDENTE_TOTAL)*100),'999G999G999G999G990D00')) "%30d",
       A."60d", to_number(to_char(((A."60d"/QTD_PENDENTE_TOTAL)*100),'999G999G999G999G990D00')) "%60d", 
       A."90d", to_number(to_char(((A."90d"/QTD_PENDENTE_TOTAL)*100),'999G999G999G999G990D00')) "%90d",
       A."120d", to_number(to_char(((A."120d"/QTD_PENDENTE_TOTAL)*100),'999G999G999G999G990D00')) "%120d", 
       A."+180d", to_number(to_char(((A."+180d"/QTD_PENDENTE_TOTAL)*100),'999G999G999G999G990D00')) "%+180d",
       QTD_PENDENTE
       FROM (
SELECT
   A.CD, A.DS_ESTAB_LOCALIZ, A."30d", A."60d", A."90d", A."120d", A."+180d", SUM(A.QTD_PENDENTE) QTD_PENDENTE,
   MAX((SELECT 
    SUM(A.QTD_PENDENTE)
    FROM UNIMED_SUBINDICADOR_BACKLOG A))  QTD_PENDENTE_TOTAL
FROM UNIMED_SUBINDICADOR_BACKLOG A
GROUP BY A.CD, A.DS_ESTAB_LOCALIZ, A."30d", A."60d", A."90d", A."120d", A."+180d") A
UNION ALL
SELECT 1,
       'TOTAL' DS_ESTAB_LOCALIZ, 
       sum(A."30d"), to_number(to_char(((sum(A."30d")/max(QTD_PENDENTE_TOTAL))*100),'999G999G999G999G990D00')) "%30d",
       sum(A."60d"), to_number(to_char(((sum(A."60d")/max(QTD_PENDENTE_TOTAL))*100),'999G999G999G999G990D00')) "%60d", 
       sum(A."90d"), to_number(to_char(((sum(A."90d")/max(QTD_PENDENTE_TOTAL))*100),'999G999G999G999G990D00')) "%90d",
       sum(A."120d"), to_number(to_char(((sum(A."120d")/max(QTD_PENDENTE_TOTAL))*100),'999G999G999G999G990D00')) "%120d", 
       sum(A."+180d"), to_number(to_char(((sum(A."+180d")/max(QTD_PENDENTE_TOTAL))*100),'999G999G999G999G990D00')) "%+180d",
       sum(QTD_PENDENTE)
       FROM (
SELECT
   A.CD, A.DS_ESTAB_LOCALIZ, A."30d", A."60d", A."90d", A."120d", A."+180d", SUM(A.QTD_PENDENTE) QTD_PENDENTE,
   MAX((SELECT 
    SUM(A.QTD_PENDENTE)
    FROM UNIMED_SUBINDICADOR_BACKLOG A))  QTD_PENDENTE_TOTAL
FROM UNIMED_SUBINDICADOR_BACKLOG A
GROUP BY A.CD, A.DS_ESTAB_LOCALIZ, A."30d", A."60d", A."90d", A."120d", A."+180d") A
group by 1
order by 1,qtd_pendente desc;
