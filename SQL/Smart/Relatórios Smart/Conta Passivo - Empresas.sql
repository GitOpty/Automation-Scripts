SELECT emp.emp_cod as Código,
    emp.emp_nome_fantasia as Nome_Fantasia,
    case when emp.emp_tipo = 'F' then 'Fornecedor'
         when emp.emp_tipo = 'C' then 'Cliente'
         when emp.emp_tipo = 'A' then 'Cliente/Fornecedor'
    end as Tipo,
    emp.emp_cgc as CNPJ,
    emp.emp_cct_cod as Conta_Passivo,
    case when emp.emp_status = 'A' then 'Ativo'
         when emp.emp_status = 'S' then 'Suspenso'
         when emp.emp_status = 'I' then 'Inativo p/ Tesouraria'
    end as Status
FROM emp
WHERE emp.emp_cod <> 0
ORDER BY emp.emp_nome_fantasia ASC