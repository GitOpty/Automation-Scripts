CREATE VIEW
    [dbo].[v_bi_ctf]
AS

    SELECT
        x.ctf_cod    
        ,x.ctf_tipo
        ,case
            when UPPER(x.ctf_categ) = 'C' then 'Consultas'
            when UPPER(x.ctf_categ) = 'R' then 'Cirurgias'
            when UPPER(x.ctf_categ) = 'E' then 'Exames'
            when UPPER(x.ctf_categ) = 'T' then 'Taxas'
            when UPPER(x.ctf_categ) = 'D' then 'Diárias'
            when UPPER(x.ctf_categ) = 'A' then 'Terapia'
            when UPPER(x.ctf_categ) = 'M' then 'Materiais'
            when UPPER(x.ctf_categ) = 'S' then 'Materiais Especiais'
            when UPPER(x.ctf_categ) = 'N' then 'Medicamentos'
            when UPPER(x.ctf_categ) = 'G' then 'Gases'
            when UPPER(x.ctf_categ) = 'O' then 'Outros'
          end DS_CLASSIF_PROCEDIMENTO  
    from dbo.ctf x
    