----------------------------------------------------------
--Consulta Municipios Diferente de 530010-----------------
----------------------------------------------------------
select  a.cd_pessoa_fisica
        ,obter_nome_pf(a.cd_pessoa_fisica) as nome
        ,A.DS_MUNICIPIO AS MUNICIPIO
        , A.CD_MUNICIPIO_IBGE AS CD_MUNICIPIO_IBGE
        , B.DS_MUNICIPIO AS MUNICIPIO_IBGE
from    COMPL_PESSOA_FISICA A
        INNER JOIN SUS_MUNICIPIO B ON B.CD_MUNICIPIO_IBGE = A.CD_MUNICIPIO_IBGE
where   b.DS_UNIDADE_FEDERACAO = 'DF'
        and b.CD_MUNICIPIO_IBGE <> '530010'
        
        
----------------------------------------------------------
--Altera todos os município diferente 530010--------------
----------------------------------------------------------

UPDATE COMPL_PESSOA_FISICA a
SET a.CD_MUNICIPIO_IBGE = '530010'
where   a.CD_MUNICIPIO_IBGE = 
        (select  b.CD_MUNICIPIO_IBGE
        from    SUS_MUNICIPIO b
        where   b.CD_MUNICIPIO_IBGE = a.CD_MUNICIPIO_IBGE
                and b.DS_UNIDADE_FEDERACAO = 'DF'
                and b.CD_MUNICIPIO_IBGE <> '530010') 
                