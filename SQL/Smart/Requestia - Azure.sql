
SELECT  top 10 request as Chamado
        , abertura as DT_Abertura
        , resolucao as DT_Resolucao
        , client as Solicitante
        , curranal as Analista
        , orgunit as Unidade_Origem
        , unidade_atendimento as Unidade_Atendimento
        , product as Produto
        , process as Processo
        , rstatus as Status
        , [%_SLA] as SLA
        , PRAZO_RESL as Atendimento
        , REQLOCATION as Cidade
FROM    requestia_requests
WHERE   category = 'Tecnologia da Informação'
        --and abertura between ('2020-01-01 00:00:00.000') and ('2020-07-31 23:59:00.000')        
ORDER BY 1 DESC



/*AND rstatus <> 'Encerrado' 
        AND rstatus <> 'Cancelado Abertura Incorreta'
        AND rstatus <> 'Encaminhar para Aprovação do Solicitante'
        AND rstatus <> 'Encerrado - Falta de Retorno'
        AND rstatus <> 'Cancelado a Pedido do Cliente'
        AND rstatus <> 'Aguardando Aprovação'
        AND rstatus <> 'Reprovado'
        AND curranal = 'Willian Cruz'
        --AND product = 'Philips Tasy'*/

/*
select  count( request ) as total
from    requestia_requests 
where   category = 'Tecnologia da Informação' 
        and abertura between ('2019-06-19 00:00:00.000') and ('2019-07-19 23:59:00.000') 
        --and product = 'Philips Tasy'
        --and product = 'Pixeon Smart'
*/