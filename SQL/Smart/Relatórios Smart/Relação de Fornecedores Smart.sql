--Relação de Fornecedores

SELECT  cgc AS 'CPF_CNPJ'
        , (SELECT TOP 1 emp_nome_fantasia FROM emp WHERE emp_cgc = cgc) AS 'NOME_PESSOA'
        , (SELECT TOP 1 CASE WHEN (emp.emp_fis_jur = 'J' OR (LEN(emp.emp_cgc) = 14)) THEN 'Jurídica'
                             WHEN (emp.emp_fis_jur = 'F' OR (LEN(emp.emp_cgc) = 11)) THEN 'Física'
                        END AS 'TIPO_PESSOA'
           FROM     EMP EMP
           WHERE    emp_cgc = cgc
          ) AS 'TIPO_PESSOA'
        , (SELECT TOP 1 CASE WHEN fne.FNE_TIPO = 'FO' THEN 'Fornecedor'
                             WHEN fne.FNE_TIPO = 'FT' THEN 'Forn_Transportador'
                             WHEN fne.FNE_TIPO = 'TR' THEN 'Transportador'
                             WHEN fne.FNE_TIPO = 'FF' THEN 'Forn_Fabricante'  
                        END AS 'TIPO'
           FROM     FNE FNE
          ) AS 'TIPO'
        , (SELECT TOP 1 CASE WHEN fne.FNE_STATUS = 'A' THEN 'Ativo'
                             WHEN fne.FNE_STATUS = 'I' THEN 'Inativo'
                        END AS 'STATUS'
           FROM FNE FNE 
          ) AS 'STATUS'
        , 'Itaigara' as EMPRESA
FROM    ((SELECT  (SELECT top 1 emp_cgc FROM emp WHERE emp_fne_cod = fne_cod) AS CGC        
          FROM    fne        
          WHERE   (fne.FNE_DEL_LOGICA IS NULL OR (fne.FNE_DEL_LOGICA = 'N'))
                  AND fne.FNE_STATUS = 'A'
        )) t1
WHERE   cgc IS NOT NULL
GROUP BY cgc HAVING count(cgc) > 1
-----------------------------------------------------------------------------------------------------------------------------
--Versão de Cadu
/*
SELECT cgc
    , count(cgc)
    , (
        SELECT TOP 1 emp_nome_fantasia
        FROM emp
        WHERE emp_cgc = cgc
        ) AS emp_nome
FROM (
    SELECT --emp.emp_cgc AS 'CNPJ_CPF'
        fne.FNE_NOME_FANTASIA AS 'NOME_PESSOA'
        -- , CASE 
        --     WHEN (
        --             emp.emp_fis_jur = 'J'
        --             OR (LEN(emp.emp_cgc) = 14)
        --             )
        --         THEN 'Jurídica'
        --     WHEN (
        --             emp.emp_fis_jur = 'F'
        --             OR (LEN(emp.emp_cgc) = 11)
        --             )
        --         THEN 'Física'
        --     END AS 'TIPO_PESSOA'
        , CASE 
            WHEN fne.FNE_TIPO = 'FO'
                THEN 'Fornecedor'
            WHEN fne.FNE_TIPO = 'FT'
                THEN 'Forn_Transportador'
            WHEN fne.FNE_TIPO = 'TR'
                THEN 'Transportador'
            WHEN fne.FNE_TIPO = 'FF'
                THEN 'Forn_Fabricante'
            END AS 'TIPO'
        , CASE 
            WHEN fne.FNE_STATUS = 'A'
                THEN 'Ativo'
            WHEN fne.FNE_STATUS = 'I'
                THEN 'Inativo'
            END AS 'STATUS'
        , 'Itaigara' AS EMPRESA
        , (
            SELECT top 1 emp_cgc
            FROM emp
            WHERE emp_fne_cod = fne_cod
            ) AS CGC
    FROM fne
    WHERE (
            fne.FNE_DEL_LOGICA IS NULL
            OR (fne.FNE_DEL_LOGICA = 'N')
            )
        AND fne.FNE_STATUS = 'A'
    ) t1
WHERE cgc IS NOT NULL
GROUP BY cgc
HAVING count(cgc) > 1*/