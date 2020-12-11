SELECT convert(varchar, ipg_cpg_serie) + '.' + convert(varchar, ipg_cpg_num) as Compromisso,
    ipg.ipg_parc as Parc,
    ipg.ipg_dt_pgto as Dt_Pagamento,
    cpg.cpg_credor as Credor,
    CASE WHEN cpg.cpg_tipo_compromisso = 'N' THEN 'Nota Fiscal'
         WHEN cpg.cpg_tipo_compromisso = 'A' THEN 'Adiantamento' 
         WHEN cpg.cpg_tipo_compromisso = 'T' THEN 'Título' 
         WHEN cpg.cpg_tipo_compromisso = 'O' THEN 'Outro'
         WHEN cpg.cpg_tipo_compromisso = 'F' THEN 'Frete'
         WHEN cpg.cpg_tipo_compromisso = 'I' THEN 'Imposto'
         WHEN cpg.cpg_tipo_compromisso = 'M' THEN 'Folha de Pag.'
         WHEN cpg.cpg_tipo_compromisso = 'G' THEN 'Pag. a Prestador'
         END as Tipo,
    cpg.cpg_doc as Documento,
    ipg.ipg_valor as Valor,
    CASE WHEN ipg.ipg_status = 'P' THEN 'Pago' END as Situação,
    CASE WHEN cpg.cpg_pagamento = '9999' THEN '[Não especificado]'
         WHEN cpg.cpg_pagamento = '1' THEN 'BANCO DO BRASIL'
         END as Pagamento,
    cpg.cpg_tot_parc as Parcelas,
    cpg.cpg_cic_rg as CPF_CNPJ,
    cpg.cpg_obs as Obs,
    ipg.ipg_dt_vcto as Dt_Vencimento,
    convert(varchar, ipg.ipg_bcp_serie) + '.' + convert(varchar, ipg.ipg_bcp_num) as Baixa,
    bcp.bcp_dthr as Dt_Baixa,
    CASE WHEN bcp.bcp_tipo_pag = 'BDR' THEN 'Borderô' END as Tipo,
    gcc.gcc_descr as Empresa,
    tpg.tpg_descr as Tipo_Pagamento
FROM ipg
    LEFT JOIN bcp ON ipg.ipg_bcp_serie = bcp.bcp_serie AND ipg.ipg_bcp_num = bcp.bcp_num, cpg
    LEFT JOIN tpg ON cpg.cpg_tpg_cod = tpg.tpg_cod, gcc
WHERE 1 = 1
    AND (cpg.cpg_serie = ipg.ipg_cpg_serie)
    AND (cpg.cpg_num = ipg.ipg_cpg_num)
    AND (gcc.gcc_cod = cpg.cpg_gcc_cod)
    AND ((ipg.ipg_status IN ('R','P'))
        AND (ipg.ipg_dt_pgto >= '2019-01-25 00:00:00.000')
        AND (ipg.ipg_dt_pgto <= '2019-09-30 23:59:59.000')
        AND (cpg.cpg_tipo_compromisso LIKE '%')
        AND (cpg.cpg_fis_jur LIKE '%')
        AND (cpg.cpg_credor LIKE '%')
        AND (cpg.cpg_gcc_cod LIKE 'DHI' OR (ipg.ipg_gcc_cod_colig = 'DHI')))
    AND cpg.cpg_tipo_compromisso LIKE 'A'
ORDER BY 3
