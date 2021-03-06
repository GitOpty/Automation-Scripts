select 
	cfg.cfg_emp,
	 tmp1.empresa,
    tmp1.documento,
    tmp1.data,
    tmp1.competencia,
    tmp1.cfo_cod,
	tmp1.classificacao,
    tmp1.historico,
    tmp1.movimento,
	tmp1.entradas,
    tmp1.saidas,
	case 
		when cfo_codigo_conta is null then tmp1.conciliadoem
	else tmp2.cfo_conciliadoem end as conciliadoem,	
	case 
		when cfo_codigo_conta is null then codigo_conta
	else cfo_codigo_conta end as codigo_conta,
	case 
		when cfo_codigo_conta is null then conta
	else cfo_conta end as conta, baixa
    ,chk.check_entradas,chk.check_saidas
from (
        select
			mcc.mcc_doc as documento,
			UPPER(gcc_descr) AS empresa,
			mcc.mcc_dt as data,
			convert(varchar,left(mcc.mcc_mmyy,4)) + '/' + convert(varchar,right(mcc.mcc_mmyy,2)) as competencia,
			cfo.cfo_cod,
			cfo.cfo_nome as classificacao,
			mcc.mcc_obs as historico,
			mcc.mcc_deb - mcc.mcc_cre as movimento,
			mcc.mcc_deb as entradas,mcc.mcc_cre as saidas,
			mcc.mcc_dt_compensa as conciliadoem,
			convert(varchar,mcc.mcc_serie) + '-' + convert(varchar,mcc.mcc_lote) as lote,
			ccr.ccr_cod as codigo_conta,
			ccr.ccr_tit as conta,
			isnull(convert(varchar,mcc.mcc_bcp_serie) + '-' + convert(varchar,mcc.mcc_bcp_num),'') as baixa
		from
			mcc
            inner join cfo on (cfo.cfo_cod = mcc.mcc_cfo_cod)
            inner join ccr on (ccr.ccr_cod = mcc.mcc_ccr)
				inner join gcc on (ccr_gcc_cod = gcc_cod)
		where
			((ccr_tipo = 2)
			and (mcc.mcc_tipo = 'r')
			and (mcc.mcc_concilia = 's'))
			and mcc.mcc_bcp_serie is null
			--and (mcc.mcc_dt_compensa >= :DATA_INICIAL and mcc.mcc_dt_compensa < :DATA_FINAL)
			
		union all

		select 
			mcc.mcc_doc as documento,
			UPPER(gcc_descr) AS empresa,
			mcc.mcc_dt as data,
			convert(varchar,left(mcc.mcc_mmyy,4)) + '/' + convert(varchar,right(mcc.mcc_mmyy,2)) as competencia,
			cfo.cfo_cod,cfo.cfo_nome as classificacao,mcc.mcc_obs as historico,
			mcc.mcc_cre - mcc.mcc_deb as movimento,0 as entradas,
			mcc.mcc_deb + ((ipg.ipg_valor_multa + ipg.ipg_desp_ac) * mcc.mcc_deb/ipg.ipg_valor)
			- (ipg.ipg_valor_complemento * mcc.mcc_deb/ipg.ipg_valor)
			- ((ipg.ipg_iss + ipg.ipg_irrf + ipg.ipg_inss + ipg.ipg_imp_pis 
			+ ipg.ipg_imp_cofins + ipg.ipg_imp_cssl) * mcc.mcc_deb/ipg.ipg_valor) saidas,
			mcc.mcc_dt_compensa as conciliadoem,
			convert(varchar,mcc.mcc_serie) + '-' + convert(varchar,mcc.mcc_lote) as lote,
			ccr.ccr_cod as codigo_conta,ccr.ccr_tit as conta,
			(convert(varchar,ipg.ipg_bcp_serie) + '-' + convert(varchar,ipg.ipg_bcp_num)) as mcc_baixa
		from
			mcc
            inner join cfo on (cfo.cfo_cod = mcc.mcc_cfo_cod) 
            inner join ccr on (ccr.ccr_cod = mcc.mcc_ccr) 
            inner join ipg on (ipg.ipg_cpg_serie = mcc.mcc_cpg_serie and ipg.ipg_cpg_num = mcc.mcc_cpg_num and ipg.ipg_parc = mcc.mcc_ipg_parc)
            left outer join tcc on (tcc.tcc_cod = ccr.ccr_tcc_cod) 
            left outer join cct on (cct.cct_cod = mcc.mcc_cct_cod)
				left outer join gcc on (ipg_gcc_cod_colig = gcc_cod)
		where  
			not exists (select tt.tcc_tipo from tcc tt where tt.tcc_tipo = 'W' AND tt.tcc_cod = ccr.ccr_tcc_cod)  
			and (mcc.mcc_obs <> 'Multa/Juros/Desconto' OR mcc.mcc_obs is null)   
			and ((mcc.mcc_tipo = 'P') 
			and (((mcc.mcc_ind_cpg_geracao is null or (mcc.mcc_ind_cpg_geracao = 'N')) 
			and (mcc.mcc_cre = 0)) or (mcc.mcc_ind_cpg_geracao = 'S'))) 
			and (convert(varchar,ipg.ipg_bcp_serie) + '-' + convert(varchar,ipg.ipg_bcp_num)) in
				(select distinct
					(convert(varchar,mcc.mcc_bcp_serie) + '-' + convert(varchar,mcc.mcc_bcp_num)) as mcc_baixa
				from
					mcc
                    inner join cfo on (cfo.cfo_cod = mcc.mcc_cfo_cod)
                    inner join ccr on (ccr.ccr_cod = mcc.mcc_ccr)
				where (
					 /*((mcc.mcc_dt_compensa >= :DATA_INICIAL) and (mcc.mcc_dt_compensa < :DATA_FINAL) 
					and */(mcc.mcc_tipo = 'R')
					and ccr.ccr_tipo = 2 
					and (mcc.mcc_concilia = 'S'))
					and mcc.mcc_bcp_serie <> '') 
		) as tmp1
left outer join 
		(select distinct
			convert(varchar,mcc.mcc_bcp_serie) + '-' + convert(varchar,mcc.mcc_bcp_num) as cfo_baixa,
			ccr.ccr_cod as cfo_codigo_conta,ccr.ccr_tit as cfo_conta,mcc.mcc_dt_compensa as cfo_conciliadoem
		from
			mcc
            inner join ccr on (ccr.ccr_cod = mcc.mcc_ccr)
		where
			((ccr_tipo = 2)
			and (mcc.mcc_tipo = 'r')
			and (mcc.mcc_concilia = 's'))
			and mcc.mcc_bcp_serie is not null
			--and (mcc.mcc_dt_compensa >= :DATA_INICIAL and mcc.mcc_dt_compensa < :DATA_FINAL)
		) as tmp2 on (tmp1.baixa = tmp2.cfo_baixa)
cross JOIN
	   (select 
			sum(mcc.mcc_deb) check_entradas, sum(mcc.mcc_cre) as check_saidas
		from
			mcc
            inner join ccr on (ccr.ccr_cod = mcc.mcc_ccr)
		where	
			((ccr_tipo = 2)
			and (mcc.mcc_tipo = 'r')
			and (mcc.mcc_concilia = 's'))
			--and (mcc.mcc_dt_compensa >= :DATA_INICIAL and mcc.mcc_dt_compensa < :DATA_FINAL)		
		) as chk
cross join cfg
order by
	codigo_conta desc, conta asc, data asc, conciliadoem asc