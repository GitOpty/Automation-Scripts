import requests
from requests.auth import HTTPBasicAuth
import pandas as pd
import datetime
import os 
from os import chdir, getcwd, listdir
from os.path import isfile
# from function.function_read_file_prod import *
import shlex
import xlrd2
import numpy as np

log_txt = "log_script.txt"

# REGRA UNIDADE

ESTB = np.array([
    ['TASY',1]
    ,['SMART',2]
    ,['CG',3]
    ,['RJ',4]
    ,['SADALLA',5]
    ,['OFTALMAX',6]
    ,['HCLOE',6]
])

# SHAREPOINT
link_sharepoint = "https://hospitaldeolhos93.sharepoint.com/:f:/s/BI/EiuhlsjvEfRMvuvljhlqg-UBHku3qqall8_gAwItghotbw"
usuario = "rodrigo.lima"


# CAMINHO GITHUB PYTHON
# link_github_local = "C:/Users/rodrigo.lima/MyGit/Python/Azure/output"
link_github_local = "C:/Users/rodrigo.lima/OneDrive - Opty/GitHub/Automation-Scripts/Python/Azure/output"

try:
    # response = requests.get(link_sharepoint,auth=HTTPBasicAuth(usuario,senha))    
    # print(response.status_code)
    print("t")
except:
    # print(response.status_code)
    print("Falha na conexão")

else:

    # CAMINHO LOCAL PRODUCAO
    link_local = os.path.abspath(os.path.dirname(os.path.abspath(os.path.dirname(os.path.dirname(os.path.dirname(os.getcwd())))))) + "/Opty/Business Intelligence HO BRASIL - Documentos/Projetos/Power B.I 2.0/Nova Pasta - Marco/De-para"
    # link_local = os.path.abspath(os.path.dirname(os.path.abspath(os.path.dirname(os.path.dirname(os.path.dirname(os.getcwd())))))) + "/OneDrive - Opty/MyFiles/0_files"
    # link_local = "c:/Users/rodrigo.lima/OneDrive - Opty/MyFiles/0_files"
    os.chdir(link_local)


nm_op_file = 'De-para unidades.xlsx'

# SCRIPT JOB
inicio = datetime.datetime.now()

nm_inicio = "Inicio do script: "+inicio.strftime("%Y-%m-%d %H:%M:%S")

# arq = pd.read_excel(nm_op_file)
arq = xlrd2.open_workbook(nm_op_file)
print("The number of worksheets is {0}".format(arq.nsheets))
print("Worksheet name(s): {0}".format(arq.sheet_names()))

# MAPEANDO AS ABAS
aba = arq.sheet_names()
nm_aba = [x.upper().split('-') for x in aba]


k = 0
for i in range(len(nm_aba)):
    list_aba = []
    for x in range(len(nm_aba[i])):
        list_aba.insert(x,nm_aba[i][x].strip())

    # ABAS QUE PRECISA  SER SELECIONADA
    word_find = ['CONVENIO','CONVENIOS']
    
    # COLUNAS QUE PRECISAM SER SELECIONADA
    word_col_find = ['CodConvenio'
                        ,'COD_CONVENIO'
                        ,'ID'
                        ,'cd_convenio'
                        ,'Convenio'
                        ,'CONVENIO'
                        ,'Convenios'
                        ,'Convênio'
                        ,'De-para'
                        ,'De-para Convenio'
                        ,'Convenio Ajustado'
                        ,'Categoria convenio'
                        ,'Categoria convênio'
                        ,'Tipo Convenio'
                        ,'Convenio/Particular'
                      ]

    # ORDER DAS COLUNAS
    order1 = ['COD_CONVENIO','ID','cd_convenio']
    order2 = ['COnvenio','CONVENIO','Convenios','Convenio']
    order3 = ['De-para','De-para Convenio','Convenio Ajustado']
    order4 = ['Categoria convenio','Categoria convênio','Tipo Convenio','Convenio/Particular']


    try:
        busca = list(set(word_find).intersection(list_aba))
        
        if len(busca) > 0:
            sh = arq.sheet_by_index(i)
            nm_sh = aba[i]
            df = pd.read_excel(nm_op_file,sheet_name=nm_sh)

            try:
                
                header = list(df.columns.values)
                busca_col = list(set(word_col_find).intersection(header))


                for q in range(len(busca_col)):
                    nm = busca_col[q]

                    if q == 0:
                        new_df = pd.DataFrame(df[nm])
                    else:
                        new_df[nm] = df[nm]    
                

                n_header = list(new_df.columns.values)


                f_col = list(set(order1).intersection(n_header))                
                f_col2 = list(set(order2).intersection(n_header))
                f_col3 = list(set(order3).intersection(n_header))
                f_col4 = list(set(order4).intersection(n_header))

                # SE NÃO EXISTIR COD

                if len(f_col) == 0:
                    new_df['Codigo'] = 0

                try:
                    new_df = new_df.rename({f_col[0]:'CODIGO'}, axis='columns')
                except:
                    print(nm_sh)

                new_df = new_df.rename({f_col2[0]:'DESCRICAO'}, axis='columns')
                new_df = new_df.rename({f_col3[0]:'CONVENIO_DEPARA'}, axis='columns')
                new_df = new_df.rename({f_col4[0]:'TP_CONVENIO'}, axis='columns')


                
                array_nm_aba = np.array(nm_aba)    
                sel_array = list(set(array_nm_aba[i]))

                for b in range(len(ESTB)):
                    # ref = list(set(ESTB[b]))
                    
                    sel_array_x = [x.upper().split(' ') for x in sel_array]

                    for t in range(len(sel_array_x)):
                        nw = sel_array_x[t]
                        try:
                            nw.remove('')
                            unidade = [ESTB[b][0]]
                            f = list(set(nw).intersection(unidade))
                            if len(f) > 0:
                                new_df['COD_SYS'] = ESTB[b][1]
                                new_df['NM_SYS'] = ESTB[b][0]
                        except:
                            print("Sem dados")    


                    # nAba = nm_aba[i][1].strip()
                    
                    # if nAba == ESTB[b][0]:
                    #     new_df['cod_sys'] = ESTB[b][1] 
                    #     new_df['nm_sys'] = ESTB[b][0] 

                col_names = ['COD_SYS','NM_SYS','CODIGO','DESCRICAO','CONVENIO_DEPARA','TP_CONVENIO']
                new_df = new_df.reindex(columns=col_names)

                if k == 0:
                    df_final = pd.DataFrame(new_df)
                else:
                    df_final = df_final.append(new_df,ignore_index=True)
                  

                lin_df = len(new_df)
                lin_final = len(df_final)    
                k = +1
            except Exception as m:
                print(m)

            # finally:
   

    except Exception as e:
        print(e)    
        next

# CONVERT FORMAT
df_final.update(df_final['CODIGO'].fillna(0)) 
df_final.astype({"COD_SYS":'int32'}).dtypes
df_final.astype({"CODIGO":'int64'}).dtypes

nm_arq_root = link_github_local + '/depara_sys_regra_convenio.csv'    
salva_arq = df_final.to_csv(nm_arq_root,encoding='utf-8-sig',index=False)

fim = datetime.datetime.now()
nm_fim = "Fim do script: "+fim.strftime("%Y-%m-%d %H:%M:%S")

# GRAVAR LOG

try:
    # nome_arquivo = input('log_script.txt')
    nome_arquivo = link_github_local + '/log_script.txt'
    arquivo = open(nome_arquivo, 'r+')
except FileNotFoundError:
    arquivo = open(nome_arquivo, 'w')
    # arquivo.writelines(u'Arquivo criado pois nao existia')

i=int(0)

info = [nm_inicio,nm_fim]

for i in range(len(info)):

    arquivo.write('depara_sys_regra ' + str(info[i])+"\n")

arquivo.close()