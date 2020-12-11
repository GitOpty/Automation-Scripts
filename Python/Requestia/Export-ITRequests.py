"""
Objetivo:
    Automatiza a tarefa de exportar a lista de chamados de TI do Requestia, usando o Selenium
Criado por:
    Sergio Queiroz
Histórico de revisões:
    05/04/2019 - Versão inicial
    13/07/2019 - Ofusca as credenciais e formata o código
"""

# Exemplo do arquivo credentials.py
#
# requestia = {
#    'username' : 'meu_usuario',
#    'password' : 'minha_senha'
# }
import credentials
import os
import sentry_sdk
from time import sleep
from selenium import webdriver

# Inicializa a captura de erros do Sentry.io
sentry_sdk.init("https://e6900d2c0abc49758e7b87a3ef7590ab@sentry.io/1505496")

# Inicia o Selenium
browser = webdriver.Chrome(
    'C:/Users/sergio.queiroz/OneDrive - Opty/PowerShell-Library/chromedriver.exe')
browser.implicitly_wait(5)


def login(url, user, password):
    # Acessa a página da aplicação e informa as credenciais
    browser.get(url)
    sleep(10)
    browser.find_element_by_xpath(
        '//*[@id="txtLogin"]').send_keys(user)
    browser.find_element_by_xpath(
        '//*[@id="txtPwd"]').send_keys(password)
    browser.find_element_by_id('ext-gen28').click()


def make_search(category):
    # Clica na árvore de navegação: Minhas tarefas / Pesquisar
    browser.find_element_by_xpath(
        '//*[@id="ext-gen119"]/div/li[2]/ul/li[2]/div/a/span').click()
    # Informa a Categoria
    browser.find_element_by_xpath(
        '/html[1]/body[1]/div[2]/div[3]/div[2]/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[2]/div[1]/div[6]/div[2]/div[1]/div[1]/input[1]').click()
    sleep(5)
    browser.find_element_by_xpath(
        '/html[1]/body[1]/div[2]/div[3]/div[2]/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[2]/div[1]/div[6]/div[2]/div[1]/div[1]/input[1]').send_keys(category)
    # Seleciona todos os chamados
    browser.find_element_by_xpath(
        '/html[1]/body[1]/div[2]/div[3]/div[2]/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[2]/div[1]/div[10]/div[1]/div[3]/div[1]/div[1]/div[1]/input[1]').click()
    # Clica no botão Procurar
    sleep(5)
    browser.find_element_by_xpath(
        '/html[1]/body[1]/div[2]/div[3]/div[2]/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/div[2]/div[1]/table[1]/tbody[1]/tr[1]/td[1]/table[1]/tbody[1]/tr[1]/td[1]/table[1]/tbody[1]/tr[2]/td[2]/em[1]/button[1]').click()


def delete_data(filepath):
    # Apaga o arquivo anterior, pois o Requestia sempre exporta com o mesmo nome de arquivo
    if os.path.exists(filepath):
        os.remove(filepath)


def export_data():
    sleep(15)
    # Clica no botão Exportar
    browser.find_element_by_xpath(
        '/html[1]/body[1]/div[2]/div[3]/div[2]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[2]/div[1]/table[1]/tbody[1]/tr[1]/td[1]/table[1]/tbody[1]/tr[1]/td[12]/table[1]/tbody[1]/tr[2]/td[2]/em[1]').click()
    sleep(20)


def close_browser():
    # Ajuste, em função da velocidade de conexão
    sleep(10)
    browser.close()


username = credentials.requestia['username']
password = credentials.requestia['password']

login('https://csi.requestia.com/', username, password)
make_search('Tecnologia da Informação')
delete_data('C:/Users/sergio.queiroz/Downloads/Caixa_de_Entrada.xlsx')
export_data()
close_browser()
