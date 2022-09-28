SELECT R.REQUEST CHAMADO
    , CONVERT(VARCHAR(10), R.ABERTURA, 103) ABERTURA
    , UPPER(R.RSTATUS) STATUS
    , UPPER(R.CLIENT) SOLICITANTE
    , UPPER(R.CURRANAL) ANALISTA
    , R.MARCA MARCA
    , R.[UNIDADE ATENDIMENTO] UNIDADE
    , R.[SIGLA UNIDADE] SIGLA
    , A1.QANSWER PROJETO
    , A2.QANSWER FORNECEDOR
    , A3.QANSWER OBSERVACAO
    , A4.QANSWER VALOR
    , CONVERT(VARCHAR(10), CONVERT(DATE, A5.QANSWER, 111), 103) EMISSAO
    , A6.QANSWER NF
INTO dbo.REQUESTIA_CAPEXNFD
FROM REQUESTIA_REQUESTS R
    LEFT JOIN REQUESTIA_QANSWER A1
        ON R.QSESSIONFORM = A1.QSESSION AND A1.QUESTION = 'CAP_CAPEX_CC'
    LEFT JOIN REQUESTIA_QANSWER A2
        ON R.QSESSIONFORM = A2.QSESSION AND A2.QUESTION = 'CONTAS_PGTO_Forn'
    LEFT JOIN REQUESTIA_QANSWER A3
        ON R.QSESSIONFORM = A3.QSESSION AND A3.QUESTION = 'CONTAS_PGTO_Observacao'
    LEFT JOIN REQUESTIA_QANSWER A4
        ON R.QSESSIONFORM = A4.QSESSION AND A4.QUESTION = 'CONTAS_PGTO_Valor'
    LEFT JOIN REQUESTIA_QANSWER A5
        ON R.QSESSIONFORM = A5.QSESSION AND A5.QUESTION = 'CONTAS_PGTO_DataEmis'
    LEFT JOIN REQUESTIA_QANSWER A6
        ON R.QSESSIONFORM = A6.QSESSION AND A6.QUESTION = 'CONTAS_PGTO_NDocumento'
WHERE R.CATEGORY = 'Contas a Pagar'
    AND R.PRODUCT = 'Solicitação de CAPEX'
    AND R.PROCESS = 'Registro de NFDs'
    AND R.RSTATUS NOT LIKE '%Cancel%'
    --AND R.ABERTURA >= GETDATE()-60
ORDER BY 1 DESC

SELECT *
FROM REQUESTIA_CAPEXNFD NFD


SELECT R.REQUEST, R.ABERTURA
FROM REQUESTIA_REQUESTS R
WHERE R.ABERTURA >= '01/08/2019'
WHERE R.REQUEST = 'CSI082835'

SELECT A1.*
FROM REQUESTIA_QANSWER A1
WHERE A1.QSESSION = 165121
    AND A1.QUESTION = 'CAP_CAPEX_CC'

EXECUTE dbo.sp_TRUNCATEREQUESTS

SELECT TOP 10 *
FROM REQUESTIA_QTABLEANSWER T
WHERE T.QSESSION = 147108

SELECT *
FROM REQUESTIA_REQUESTS R
WHERE R.REQUEST = 'CSI073728'