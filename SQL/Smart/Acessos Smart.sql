/*SELECT * FROM fnc WHERE fnc_cod IN ('CADEMP','CADGFCON')
-----------------------------------------------------------------
SELECT acs.acs_grp_cod,
    acs.acs_nivel,
    acs.acs_fnc_cod,
    grp.grp_descr
FROM acs,
    grp
WHERE (grp.grp_cod = acs.acs_grp_cod)
    AND ((acs.acs_fnc_cod = 'CADEMP'))
ORDER BY grp.grp_descr ASC*/
------------------------------------------------------------------
/*SELECT * 
FROM usr
WHERE usr_grp = 'CAD'*/
------------------------------------------------------------------
/*SELECT  grp_cod,
        grp_descr,
        fnc_cod,
        fnc_descr
FROM grp 
    INNER JOIN acs ON grp_cod = acs_grp_cod
    INNER JOIN fnc ON fnc_cod = acs_fnc_cod
WHERE grp_cod = 'CAD'*/
------------------------------------------------------------------

SELECT usr_login
    , UPPER(usr_nome) AS usr_nome
    , str_nome AS 'setor_nome'
    , grp_descr
    , usr_nivel AS 'nivel_usuario'
    , acs_nivel AS 'nivel_grupo'
    , acs_fnc_cod
    , fnc_descr 
FROM acs
INNER JOIN grp
    ON (grp_cod = acs_grp_cod)
INNER JOIN usr
    ON usr_grp = grp_cod
INNER JOIN fnc
    ON fnc_cod = acs_fnc_cod
LEFT OUTER JOIN str
    ON str_cod = usr_str_cod
WHERE usr_status = 'A' AND fnc_cod IN ('CADEMP')
    --AND usr_nivel >= acs_nivel

UNION ALL

SELECT usr_login
    , usr_nome
    , str_nome
    , grp_descr
    , usr_nivel
    , NULL AS acs_nivel
    , uaf_fnc_cod
    , fnc_descr
FROM uaf
INNER JOIN usr
    ON usR_login = uaf_usr_login
LEFT OUTER JOIN str
    ON str_cod = usr_str_cod
INNER JOIN grp
    ON (grp_cod = usr_grp)
INNER JOIN fnc
    ON fnc_cod = uaf_fnc_cod
WHERE usr_status = 'A' AND fnc_cod IN ('CADEMP')
    --AND usr_nivel >= acs_nivel
ORDER BY 1
