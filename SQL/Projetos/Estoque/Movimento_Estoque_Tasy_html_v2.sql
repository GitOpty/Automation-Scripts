select operacao_estoque.cd_operacao_estoque,
    dt_movimento_estoque,
    movimento_estoque.cd_local_estoque,
    ds_local_estoque,
    movimento_estoque.cd_estabelecimento,
    nm_fantasia_estab,
    movimento_estoque.nr_documento,
    movimento_estoque.cd_material,
    case 
        when ds_familia is null then 'Sem classificação'
        else ds_familia
        end familia_padrao,
    ds_classe_material classe_material,
    ds_subgrupo_material Subgrupo,
    ds_grupo_material Grupo,
    ds_fabricante Fabricante,
    ds_reduzida,
    ds_operacao,
    ie_entrada_saida,
    cd_acao,
    case 
        when ds_operacao in ('Consumo', 'Execução Prescrição', 'Consumo da Produção')
        then to_char(sum(qt_movimento)/(avg(QT_CONV_ESTOQUE_CONSUMO)))
        else to_char(sum(qt_movimento))
        end qt_movimento,
    to_char(sum(case when movimento_estoque_valor.cd_tipo_valor = 5 then - movimento_estoque_valor.vl_movimento else + movimento_estoque_valor.vl_movimento end )) valor_movimento
    
    from FAST_OPS.movimento_estoque
    left join FAST_OPS.operacao_estoque
    on movimento_estoque.cd_operacao_estoque = operacao_estoque.cd_operacao_estoque
    
    left join FAST_OPS.estabelecimento
    on (movimento_estoque.cd_estabelecimento = estabelecimento.cd_estabelecimento)
    
    left join FAST_OPS.local_estoque
    on (local_estoque.cd_estabelecimento = movimento_estoque.cd_estabelecimento AND
        local_estoque.cd_local_estoque = movimento_estoque.cd_local_estoque)
        
    left join FAST_OPS.material
    on (movimento_estoque.cd_material = material.cd_material) 
    
    left join FAST_OPS.material_familia
    on (material.nr_seq_familia = material_familia.nr_sequencia)
    
    left join FAST_OPS.classe_material
    on (material.cd_classe_material = classe_material.cd_classe_material)
    
    left join FAST_OPS.subgrupo_material
    on (classe_material.cd_subgrupo_material = subgrupo_material.cd_subgrupo_material)
    
    left join FAST_OPS.grupo_material
    on (subgrupo_material.cd_grupo_material = grupo_material.cd_grupo_material)
    
    left join FAST_OPS.mat_fabricante
    on material.nr_seq_fabric =  mat_fabricante.nr_sequencia
    
    left join FAST_OPS.movimento_estoque_valor
    on movimento_estoque_valor.nr_movimento_estoque = movimento_estoque.nr_movimento_estoque

    where dt_movimento_estoque >= '01/01/2020'

    GROUP BY operacao_estoque.cd_operacao_estoque,
        dt_movimento_estoque,
        movimento_estoque.cd_local_estoque,
        ds_local_estoque, movimento_estoque.cd_estabelecimento,
        nm_fantasia_estab,
        movimento_estoque.nr_documento,
        movimento_estoque.cd_material,
        case when ds_familia is null then 'Sem classificação' else ds_familia end,
        ds_classe_material,
        ds_subgrupo_material,
        ds_grupo_material,
        ds_fabricante,
        ds_reduzida,
        ds_operacao,
        ie_entrada_saida,
        cd_acao
