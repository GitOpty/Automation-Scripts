SELECT usr_login
    , UPPER(usr_nome) AS usr_nome
    , str_nome
    , (
        SELECT CONVERT(VARCHAR, max(gr_ses_dthr_ini), 103)
        FROM gr_ses
        WHERE gr_usr_login = usr_login
        ) AS ultimo_login
    , grp_cod
    , grp_descr
    , usr_nivel
    , acs_nivel
    , acs_fnc_cod
    , fnc_descr
    , CASE 
        WHEN usr_nivel >= acs_nivel
            THEN 'Permitir'
        ELSE 'Negado'
        END AS permissao_efeitva
    , FNC_AREA
    , FNC_OBS
    , 'GRUPO' AS tipo_acesso
FROM acs
INNER JOIN grp
    ON (grp_cod = acs_grp_cod)
INNER JOIN usr
    ON usr_grp = grp_cod
INNER JOIN fnc
    ON fnc_cod = acs_fnc_cod
LEFT OUTER JOIN str
    ON str_cod = usr_str_cod
WHERE usr_status = 'A'
 
UNION ALL
 
SELECT usr_login
    , usr_nome
    , str_nome
    , (
        SELECT CONVERT(VARCHAR, max(gr_ses_dthr_ini), 103)
        FROM gr_ses
        WHERE gr_usr_login = usr_login
        ) AS ultimo_login
    , grp_cod
    , grp_descr
    , usr_nivel
    , NULL AS acs_nivel
    , uaf_fnc_cod
    , fnc_descr
    , CASE 
        WHEN uaf_ind_acesso = 'S'
            THEN 'Permitir'
        ELSE 'Negado'
        END AS permissao_efetiva
    , FNC_AREA
    , FNC_OBS
    , 'USUÁRIO' AS tipo_acesso
FROM uaf
INNER JOIN usr
    ON usR_login = uaf_usr_login
LEFT OUTER JOIN str
    ON str_cod = usr_str_cod
INNER JOIN grp
    ON (grp_cod = usr_grp)
INNER JOIN fnc
    ON fnc_cod = uaf_fnc_cod
WHERE usr_status = 'A'