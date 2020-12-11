--Alteração de CNPJ na tela de Compromissos a Pagar na Tesouraria
update cpg 
set cpg_cic_rg = '33041260161508'
where cpg_num = 3599
and cpg_serie = 1119


update cpg 
set CPG_EMP_COD = '4534'
where cpg_num = 3599
and cpg_serie = 1119

SELECT * FROM cpg WHERE cpg_num = 3599 AND cpg_serie = 1119

SELECT * FROM emp WHERE emp_cgc = '33041260161508'