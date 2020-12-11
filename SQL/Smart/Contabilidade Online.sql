--Para consultar o status da contabilidade, se esta online ou não:
SELECT cfg_ind_contab, * FROM cfg

SELECT * FROM ini WHERE ini_ing_cod = 'CONTAB' AND ini_cod = 'ON_LINE'
------------------------------------------------------------------------------------------------------
--Para ativar a contabilidade online:
--1º
UPDATE cfg
SET cfg_ind_contab = 'S'

--2º
UPDATE ini
SET ini_valor = 'S'
WHERE ini_ing_cod = 'CONTAB' AND ini_cod = 'ON_LINE'
------------------------------------------------------------------------------------------------------
--Para desativar a contabilidade online:
--1º
UPDATE cfg
SET cfg_ind_contab = 'N'

--2º
UPDATE ini
SET ini_valor = 'N'
WHERE ini_ing_cod = 'CONTAB' AND ini_cod = 'ON_LINE'