--Consulta Empresa e CPF do Diretor
SELECT emp.emp_nome_fantasia,
    emp.emp_cgc,
    emp.emp_diretor,
    emp.emp_diretor_cpf 
FROM emp
WHERE emp.emp_cgc LIKE '13188370000146%'

--Update para inclusão do CPF do diretor no cadastro da empresa
UPDATE emp
SET emp_diretor_cpf = '22058356888'
WHERE emp.emp_cgc LIKE '13188370000146%'


