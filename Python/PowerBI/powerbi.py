# 'dataset' tem os dados de entrada para este script

# extrai o numero da nota fiscal a partir do historico do lancamento contabil
regex = r'\s(\d+)\s'
dataset['Nota Fiscal'] = dataset['Historico'].str.extract(regex, expand=True)

# limpa caracteres que atrapalham a extração do nome do fornecedor
dataset['Historico'] = dataset['Historico'].str.replace('_', ' ')
dataset['Historico'] = dataset['Historico'].str.replace('.', ' ')
dataset['Historico'] = dataset['Historico'].str.replace('FP&A', 'FPA')
dataset['Historico'] = dataset['Historico'].str.replace('S/', 'S ')
dataset['Historico'] = dataset['Historico'].str.replace('C/', 'C ')

# extrai o nome do fornecedor a partir do historico do lancamento contabil
regex = r'(\b(?!DESPESA|DUPL|PAGAMENTO|PG|PAGTO|PROVISÃO|FATURA|FAT|DE|NF|Nº|LOCAÇÃO|VLR|VALOR|RPS|REF|RECLASSIFICAÇÃO|ENTRADA|SERVIÇO|TOMADO|NESTA|DATA|MENSAL|_NF|ANALISE|APOIO|AQUISIÇÃO|AV|BACKUP|BX|CFE|COM|COMPRA|COMPRAS|CON|CONF|DA|DO|DOC|E|EM|ESTORNO|FONE|FORN|FORNEC|FP|IMPRESSORAS|INFORMÁTICA|INTERNET|IP|TATUAPÉ|MORUMBI|ITAPEVA|JUROS|LAÇTO|LINK|Á|A|GER|TIT|DE|LANÇAMENTO|VL|RECLASSIFICACAO|Valor|C|SUPORTE|N|TELECOMUNICAÇÕES|Nota|ITAIGARA|MERCADORIAS|MOVIMENTO|Itabuna|TRANSFERÊNCIA|TATUAPE|Compras|MOV|MÊS|TÍTULO|INSTALAÇÃO|MULTA|MONITORAMENTO|IRRF|Rateio|ND|\d)\w+\b)'
dataset['Fornecedor'] = dataset['Historico'].str.extract(regex, expand=True)


DESPESA|DUPL|PAGAMENTO|PG|PAGTO|PROVISÃO|FATURA|FAT|DE|NF|Nº|LOCAÇÃO|VLR|VALOR|RPS|REF|RECLASSIFICAÇÃO|ENTRADA|SERVIÇO|TOMADO|NESTA|DATA|MENSAL|_NF|ANALISE|APOIO|AQUISIÇÃO|AV|BACKUP|BX|CFE|COM|COMPRA|COMPRAS|CON|CONF|DA|DO|DOC|E|EM|ESTORNO|FONE|FORN|FORNEC|FP|IMPRESSORAS|INFORMÁTICA|INTERNET|IP|TATUAPÉ|MORUMBI|ITAPEVA|JUROS|LAÇTO|LINK|Á|A|GER|TIT|DE|LANÇAMENTO|VL|RECLASSIFICACAO|Valor|C|SUPORTE|N|TELECOMUNICAÇÕES|Nota|ITAIGARA|MERCADORIAS|MOVIMENTO|Itabuna|TRANSFERÊNCIA|TATUAPE|Compras|MOV|MÊS|TÍTULO|INSTALAÇÃO|MULTA|MONITORAMENTO|IRRF|Rateio|ND


#################### Python Script

# 'dataset' tem os dados de entrada para este script

# extrai o numero da nota fiscal a partir do historico do lancamento contabil
regex = r'\s(\d+)\s'
dataset['Nota Fiscal'] = dataset['Historico'].str.extract(regex, expand=True)

# limpa caracteres que atrapalham a extração do nome do fornecedor
dataset['Historico'] = dataset['Historico'].str.replace('  ', ' ')
dataset['Historico'] = dataset['Historico'].str.replace('   ', ' ')
dataset['Historico'] = dataset['Historico'].str.replace('_', ' ')
dataset['Historico'] = dataset['Historico'].str.replace('.', ' ')
dataset['Historico'] = dataset['Historico'].str.replace('FP&A', 'FPA')
dataset['Historico'] = dataset['Historico'].str.replace('S/', 'S ')
dataset['Historico'] = dataset['Historico'].str.replace('C/', 'C ')
dataset['Historico'] = dataset['Historico'].str.replace('V ', '')

# extrai o nome do fornecedor a partir do historico do lancamento contabil
regex = r'(\b(?!Á|ANALISE|APOIO|AQUISIÇÃO|AV|BACKUP|BX|CFE|COM|COMPRA|CON|CONF|DA|DATA|DE|de|DESPESA|DO|DOC|DUPL|Elet|EM|ENTRADA|ESTORNO|FAT|FATURA|FONE|FORN|FORNEC|FP|GER|IMPRESSORAS|INFORMÁTICA|INSTALAÇÃO|INTERNET|IP|IRRF|ITABUNA|ITAIGARA|ITAPEVA|JUROS|LAÇTO|LANÇAMENTO|LINK|LOCAÇÃO|MENSAL|MERCADORIAS|MÊS|MONITORAMENTO|MORUMBI|MOV|MOVIMENTO|MULTA|ND|NDNESTA|NF|Nº|NOTA|Nota|PAGAMENTO|PAGTO|PARA|PG|PRO|PROV|PROVISAO|PROVISÃO|RATEIO|Rateio|RECLASS|RECLASSIFICACAO|RECLASSIFICAÇÃO|REF|RPS|SERVIÇO|SUPORTE|TATUAPE|TATUAPÉ|TÉCNICO|TELECOMUNICAÇÕES|TELEFONE|TIT|TÍTULO|TOMADO|TRANSF|TRANSFERENCIA|TRANSFERÊNCIA|Valor|VALOR|VL|VLR|\d)\w+\b)'
dataset['Fornecedor'] = dataset['Historico'].str.extract(regex, expand=True)


#################### M Script

let
    Fonte = Excel.Workbook(File.Contents("C:\Users\sergio.queiroz\OneDrive - Opty\Gestor de Orçamento\OBZ\Acomp Real vs Orçado - TI & TELECOM.xlsx"), null, true),
    Razão_Sheet = Fonte{[Item="Forecast",Kind="Sheet"]}[Data],
    #"Cabeçalhos Promovidos" = Table.PromoteHeaders(Razão_Sheet, [PromoteAllScalars=true]),
    #"Colunas Removidas" = Table.RemoveColumns(#"Cabeçalhos Promovidos",{"Ano", "Mês"}),
    #"Tipo Alterado" = Table.TransformColumnTypes(#"Colunas Removidas",{{"Orçado", type number}, {"Realizado", type number}, {"Forecast", type number}}),
    #"Colunas Removidas1" = Table.RemoveColumns(#"Tipo Alterado",{"Column14"}),
    #"Tipo Alterado1" = Table.TransformColumnTypes(#"Colunas Removidas1",{{"Data", type date}}),
    #"Tipo Alterado2" = Table.TransformColumnTypes(#"Tipo Alterado1",{{"Data", Int64.Type}}),
    #"Executar script Python" = Python.Execute("# 'dataset' tem os dados de entrada para este script#(lf)#(lf)# extrai o numero da nota fiscal a partir do historico do lancamento contabil#(lf)regex = r'\s(\d+)\s'#(lf)dataset['Nota Fiscal'] = dataset['Historico'].str.extract(regex, expand=True)#(lf)#(lf)# limpa caracteres que atrapalham a extração do nome do fornecedor#(lf)dataset['Historico'] = dataset['Historico'].str.replace('  ', ' ')#(lf)dataset['Historico'] = dataset['Historico'].str.replace('   ', ' ')#(lf)dataset['Historico'] = dataset['Historico'].str.replace('_', ' ')#(lf)dataset['Historico'] = dataset['Historico'].str.replace('.', ' ')#(lf)dataset['Historico'] = dataset['Historico'].str.replace('FP&A', 'FPA')#(lf)dataset['Historico'] = dataset['Historico'].str.replace('S/', 'S ')#(lf)dataset['Historico'] = dataset['Historico'].str.replace('C/', 'C ')#(lf)dataset['Historico'] = dataset['Historico'].str.replace('V ', '')#(lf)#(lf)# extrai o nome do fornecedor a partir do historico do lancamento contabil#(lf)regex = r'(\b(?!Á|ANALISE|APOIO|AQUISIÇÃO|AV|BACKUP|BX|CFE|COM|COMPRA|CON|CONF|DA|DATA|DE|de|DESPESA|DO|DOC|DUPL|Elet|EM|ENTRADA|ESTORNO|FAT|FATURA|FONE|FORN|FORNEC|FP|GER|IMPRESSORAS|INFORMÁTICA|INSTALAÇÃO|INTERNET|IP|IRRF|ITABUNA|ITAIGARA|ITAPEVA|JUROS|LAÇTO|LANÇAMENTO|LINK|LOCAÇÃO|MENSAL|MERCADORIAS|MÊS|MONITORAMENTO|MORUMBI|MOV|MOVIMENTO|MULTA|ND|NDNESTA|NF|Nº|NOTA|Nota|PAGAMENTO|PAGTO|PARA|PG|PRO|PROV|PROVISAO|PROVISÃO|RATEIO|Rateio|RECLASS|RECLASSIFICACAO|RECLASSIFICAÇÃO|REF|RPS|SERVIÇO|SUPORTE|TATUAPE|TATUAPÉ|TÉCNICO|TELECOMUNICAÇÕES|TELEFONE|TIT|TÍTULO|TOMADO|TRANSF|TRANSFERENCIA|TRANSFERÊNCIA|Valor|VALOR|VL|VLR|\d)\w+\b)'#(lf)dataset['Fornecedor'] = dataset['Historico'].str.extract(regex, expand=True)",[dataset=#"Tipo Alterado2"]),
    #"Value Expandido" = Table.ExpandTableColumn(#"Executar script Python", "Value", {"Data", "Marca", "Regional", "Historico", "Orçado", "Realizado", "Centro Custo", "Pacote", "Conta", "Conta Razão", "Nota Fiscal", "Fornecedor"}, {"Data", "Marca", "Regional", "Historico", "Orçado", "Realizado", "Centro Custo", "Pacote", "Conta", "Conta Razão", "Nota Fiscal", "Fornecedor"}),
    #"Tipo Alterado3" = Table.TransformColumnTypes(#"Value Expandido",{{"Data", Int64.Type}}),
    #"Tipo Alterado4" = Table.TransformColumnTypes(#"Tipo Alterado3",{{"Data", type date}}),
    #"Colunas Removidas2" = Table.RemoveColumns(#"Tipo Alterado4",{"Name"}),
    #"Tipo Alterado com Localidade" = Table.TransformColumnTypes(#"Colunas Removidas2", {{"Orçado", type number}}, "en-US"),
    #"Tipo Alterado com Localidade1" = Table.TransformColumnTypes(#"Tipo Alterado com Localidade", {{"Realizado", type number}}, "en-US")
in
    #"Tipo Alterado com Localidade1"

