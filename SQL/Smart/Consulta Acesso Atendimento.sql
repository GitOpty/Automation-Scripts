SELECT usr_login AS NM_USUÁRIO
    , 'Permite realizar alterações no registro principal da pessoa jurídica (Incluir, Alterar, Excluir)' as PERMISSÃO
    , UPPER(usr_nome) AS NM_PF_USUARIO
    , str_nome AS SETOR
    , fnc_descr as FUNÇÃO
    , grp_descr as PERFIL  
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
    AND fnc_cod IN ('REPAC')
    AND usr_nivel >= acs_nivel

UNION ALL

SELECT usr_login AS NM_USUÁRIO
    , 'Permite realizar alterações no registro principal da pessoa jurídica (Incluir, Alterar, Excluir)' as PERMISSÃO
    , usr_nome AS NM_PF_USUARIO
    , str_nome AS SETOR
    , fnc_descr as FUNÇÃO
    , grp_descr as PERFIL
FROM uaf
INNER JOIN usr
    ON usR_login = uaf_usr_login
LEFT OUTER JOIN str
    ON str_cod = usr_str_cod
INNER JOIN grp
    ON (grp_cod = usr_grp)
INNER JOIN fnc
    ON fnc_cod = uaf_fnc_cod
WHERE usr_status = 'A' AND fnc_cod IN ('REPAC')
ORDER BY 6