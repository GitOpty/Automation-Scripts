select distinct saldo_estoque.cd_estabelecimento,
    nm_fantasia_estab,
    saldo_estoque.cd_local_estoque,
    ds_local_estoque,
    saldo_estoque.cd_material,
    case 
        when ds_familia is null then 'Sem classificação'
        else ds_familia
        end familia_padrao,
    ds_classe_material classe_material,
    ds_subgrupo_material Subgrupo,
    ds_grupo_material Grupo,
    ds_fabricante Fabricante,
    ds_reduzida,    
    to_char(qt_estoque) qt_estoque,
    to_char(vl_custo_medio) vl_custo_medio
    
    from FAST_OPS.saldo_estoque
    
    left join FAST_OPS.estabelecimento
    on (saldo_estoque.cd_estabelecimento = estabelecimento.cd_estabelecimento)
    
    left join FAST_OPS.local_estoque
    on (local_estoque.cd_estabelecimento = saldo_estoque.cd_estabelecimento AND
        local_estoque.cd_local_estoque = saldo_estoque.cd_local_estoque)
        
    left join FAST_OPS.material
    on (saldo_estoque.cd_material = material.cd_material) 
    
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
    
    where dt_mesano_referencia = '01/05/2021'


