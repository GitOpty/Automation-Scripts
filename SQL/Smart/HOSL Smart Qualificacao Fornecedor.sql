SELECT APQ.apq_questionado_nome, QST.QST_TITULO, PGT.PGT_TEXTO, APQ.APQ_DTHR_REG, APQ.APQ_CONCEITO--, SUM ( APQ.APQ_NOTA ) compute006
, APQ_NOTA
, QST_COD,  APQ_QST_COD
FROM APQ WITH (NOLOCK), QST WITH (NOLOCK), PGT  WITH (NOLOCK)
WHERE  ( APQ.APQ_QST_COD = QST.QST_COD ) AND ( PGT.PGT_QST_COD = QST.QST_COD )
AND APQ.APQ_QUESTIONADO_NOME = 'BAUSCH & LOMB'
GROUP BY APQ.apq_questionado_nome, QST.QST_TITULO, PGT.PGT_TEXTO, APQ.APQ_DTHR_REG, APQ.APQ_CONCEITO
ORDER BY APQ.APQ_QUESTIONADO_NOME ASC, QST.QST_TITULO ASC
OPTION
(
LOOP
JOIN,
MAXDOP
1
) 

--- FORMULA AVALIACAO NEGOCIACAO (INDICE POSTURA COMERCIAL)
--- IPC = (SOMATORIO NOTAS / NUMERO PERGUNTAS) * 5 * 15
SELECT UPPER(APQ_QUESTIONADO_NOME) FORNECEDOR
, 
(
    (
        SELECT SUM(B.APQ_NOTA) TOTAL_NOTA
        FROM QST A
            INNER JOIN APQ B
                ON A.QST_COD = B.APQ_QST_COD
            INNER JOIN PGT C
                ON A.QST_COD = C.PGT_QST_COD
        WHERE UPPER(A.QST_TITULO) = 'AVALIAÇÃO DE NEGOCIAÇÃO'
            AND B.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
        GROUP BY UPPER(B.APQ_QUESTIONADO_NOME)
    )
    /
    (
        SELECT COUNT(1) QTDE_PERGUNTAS
        FROM QST D
            INNER JOIN APQ E
                ON D.QST_COD = E.APQ_QST_COD
            INNER JOIN PGT F
                ON D.QST_COD = F.PGT_QST_COD
        WHERE UPPER(D.QST_TITULO) = 'AVALIAÇÃO DE NEGOCIAÇÃO'
            AND E.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
        GROUP BY UPPER(E.APQ_QUESTIONADO_NOME)
    )
* 5
* 15) IPC
FROM APQ APQ_EXT

--- FORMULA AVALIACAO QUALIDADE ENTREGA
--- IQE = (SOMATORIO NOTAS / NUMERO PERGUNTAS) * 5 * 75
SELECT UPPER(APQ_QUESTIONADO_NOME) FORNECEDOR
, 
(
    (
        SELECT SUM(B.APQ_NOTA) TOTAL_NOTA
        FROM QST A
            INNER JOIN APQ B
                ON A.QST_COD = B.APQ_QST_COD
            INNER JOIN PGT C
                ON A.QST_COD = C.PGT_QST_COD
        WHERE UPPER(A.QST_TITULO) = 'AVALIAÇÃO DE QUALIDADE DE ENTREGA'
            AND B.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
        GROUP BY UPPER(B.APQ_QUESTIONADO_NOME)
    )
    /
    (
        SELECT COUNT(1) QTDE_PERGUNTAS
        FROM QST D
            INNER JOIN APQ E
                ON D.QST_COD = E.APQ_QST_COD
            INNER JOIN PGT F
                ON D.QST_COD = F.PGT_QST_COD
        WHERE UPPER(D.QST_TITULO) = 'AVALIAÇÃO DE QUALIDADE DE ENTREGA'
            AND E.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
        GROUP BY UPPER(E.APQ_QUESTIONADO_NOME)
    )
* 5
* 75) IQE
FROM APQ APQ_EXT

--- FORMULA AVALIACAO NOTA FISCAL
--- INF = (SOMATORIO NOTAS / NUMERO PERGUNTAS) * 2 * 10
SELECT UPPER(APQ_QUESTIONADO_NOME) FORNECEDOR
, 
(
    (
        SELECT SUM(B.APQ_NOTA) TOTAL_NOTA
        FROM QST A
            INNER JOIN APQ B
                ON A.QST_COD = B.APQ_QST_COD
            INNER JOIN PGT C
                ON A.QST_COD = C.PGT_QST_COD
        WHERE UPPER(A.QST_TITULO) = 'AVALIAÇÃO DE NOTA FISCAL'
            AND B.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
        GROUP BY UPPER(B.APQ_QUESTIONADO_NOME)
    )
    /
    (
        SELECT COUNT(1) QTDE_PERGUNTAS
        FROM QST D
            INNER JOIN APQ E
                ON D.QST_COD = E.APQ_QST_COD
            INNER JOIN PGT F
                ON D.QST_COD = F.PGT_QST_COD
        WHERE UPPER(D.QST_TITULO) = 'AVALIAÇÃO DE NOTA FISCAL'
            AND E.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
        GROUP BY UPPER(E.APQ_QUESTIONADO_NOME)
    )
* 2
* 10) INF
FROM APQ APQ_EXT

-- FORMULA QUALIFICACAO FORNECEDOR
-- IQF = (IPC + IQE + INF) / 100
SELECT UPPER(APQ_QUESTIONADO_NOME) FORNECEDOR
, 
(
    ISNULL((
        SELECT SUM(B.APQ_NOTA) TOTAL_NOTA
        FROM QST A
            INNER JOIN APQ B
                ON A.QST_COD = B.APQ_QST_COD
            INNER JOIN PGT C
                ON A.QST_COD = C.PGT_QST_COD
        WHERE UPPER(A.QST_TITULO) = 'AVALIAÇÃO DE NEGOCIAÇÃO'
            AND B.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
        GROUP BY UPPER(B.APQ_QUESTIONADO_NOME)
    )
    /
    (
        SELECT COUNT(1) QTDE_PERGUNTAS
        FROM QST D
            INNER JOIN APQ E
                ON D.QST_COD = E.APQ_QST_COD
            INNER JOIN PGT F
                ON D.QST_COD = F.PGT_QST_COD
        WHERE UPPER(D.QST_TITULO) = 'AVALIAÇÃO DE NEGOCIAÇÃO'
            AND E.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
        GROUP BY UPPER(E.APQ_QUESTIONADO_NOME)
    ),0)
* 5
* 15) IPC
, 
(
    ISNULL((
        SELECT SUM(B.APQ_NOTA) TOTAL_NOTA
        FROM QST A
            INNER JOIN APQ B
                ON A.QST_COD = B.APQ_QST_COD
            INNER JOIN PGT C
                ON A.QST_COD = C.PGT_QST_COD
        WHERE UPPER(A.QST_TITULO) = 'AVALIAÇÃO DE QUALIDADE DE ENTREGA'
            AND B.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
        GROUP BY UPPER(B.APQ_QUESTIONADO_NOME)
    )
    /
    (
        SELECT COUNT(1) QTDE_PERGUNTAS
        FROM QST D
            INNER JOIN APQ E
                ON D.QST_COD = E.APQ_QST_COD
            INNER JOIN PGT F
                ON D.QST_COD = F.PGT_QST_COD
        WHERE UPPER(D.QST_TITULO) = 'AVALIAÇÃO DE QUALIDADE DE ENTREGA'
            AND E.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
        GROUP BY UPPER(E.APQ_QUESTIONADO_NOME)
    ),0)
* 5
* 75) IQE
,
(
    ISNULL((
        SELECT SUM(B.APQ_NOTA) TOTAL_NOTA
        FROM QST A
            INNER JOIN APQ B
                ON A.QST_COD = B.APQ_QST_COD
            INNER JOIN PGT C
                ON A.QST_COD = C.PGT_QST_COD
        WHERE UPPER(A.QST_TITULO) = 'AVALIAÇÃO DE NOTA FISCAL'
            AND B.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
        GROUP BY UPPER(B.APQ_QUESTIONADO_NOME)
    )
    /
    (
        SELECT COUNT(1) QTDE_PERGUNTAS
        FROM QST D
            INNER JOIN APQ E
                ON D.QST_COD = E.APQ_QST_COD
            INNER JOIN PGT F
                ON D.QST_COD = F.PGT_QST_COD
        WHERE UPPER(D.QST_TITULO) = 'AVALIAÇÃO DE NOTA FISCAL'
            AND E.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
        GROUP BY UPPER(E.APQ_QUESTIONADO_NOME)
    ),0)
* 2
* 10) INF
, 
(
    ISNULL((
        (
            SELECT SUM(B.APQ_NOTA) TOTAL_NOTA
            FROM QST A
                INNER JOIN APQ B
                    ON A.QST_COD = B.APQ_QST_COD
                INNER JOIN PGT C
                    ON A.QST_COD = C.PGT_QST_COD
            WHERE UPPER(A.QST_TITULO) = 'AVALIAÇÃO DE NEGOCIAÇÃO'
                AND B.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
            GROUP BY UPPER(B.APQ_QUESTIONADO_NOME)
        )
        /
        (
            SELECT COUNT(1) QTDE_PERGUNTAS
            FROM QST D
                INNER JOIN APQ E
                    ON D.QST_COD = E.APQ_QST_COD
                INNER JOIN PGT F
                    ON D.QST_COD = F.PGT_QST_COD
            WHERE UPPER(D.QST_TITULO) = 'AVALIAÇÃO DE NEGOCIAÇÃO'
                AND E.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
            GROUP BY UPPER(E.APQ_QUESTIONADO_NOME)
        )
    * 5
    * 15),0) 
    +
    ISNULL((
        (
            SELECT SUM(B.APQ_NOTA) TOTAL_NOTA
            FROM QST A
                INNER JOIN APQ B
                    ON A.QST_COD = B.APQ_QST_COD
                INNER JOIN PGT C
                    ON A.QST_COD = C.PGT_QST_COD
            WHERE UPPER(A.QST_TITULO) = 'AVALIAÇÃO DE QUALIDADE DE ENTREGA'
                AND B.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
            GROUP BY UPPER(B.APQ_QUESTIONADO_NOME)
        )
        /
        (
            SELECT COUNT(1) QTDE_PERGUNTAS
            FROM QST D
                INNER JOIN APQ E
                    ON D.QST_COD = E.APQ_QST_COD
                INNER JOIN PGT F
                    ON D.QST_COD = F.PGT_QST_COD
            WHERE UPPER(D.QST_TITULO) = 'AVALIAÇÃO DE QUALIDADE DE ENTREGA'
                AND E.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
            GROUP BY UPPER(E.APQ_QUESTIONADO_NOME)
        )
    * 5
    * 75),0) 
    +
    ISNULL((
        (
            SELECT SUM(B.APQ_NOTA) TOTAL_NOTA
            FROM QST A
                INNER JOIN APQ B
                    ON A.QST_COD = B.APQ_QST_COD
                INNER JOIN PGT C
                    ON A.QST_COD = C.PGT_QST_COD
            WHERE UPPER(A.QST_TITULO) = 'AVALIAÇÃO DE NOTA FISCAL'
                AND B.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
            GROUP BY UPPER(B.APQ_QUESTIONADO_NOME)
        )
        /
        (
            SELECT COUNT(1) QTDE_PERGUNTAS
            FROM QST D
                INNER JOIN APQ E
                    ON D.QST_COD = E.APQ_QST_COD
                INNER JOIN PGT F
                    ON D.QST_COD = F.PGT_QST_COD
            WHERE UPPER(D.QST_TITULO) = 'AVALIAÇÃO DE NOTA FISCAL'
                AND E.APQ_QUESTIONADO_NOME = APQ_EXT.APQ_QUESTIONADO_NOME
            GROUP BY UPPER(E.APQ_QUESTIONADO_NOME)
        )
    * 2
    * 10),0) 
)/100 IQF
FROM APQ APQ_EXT
