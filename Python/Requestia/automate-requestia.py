from time import sleep
from selenium import webdriver
import os

# starting a new browser session
browser = webdriver.Chrome(
    'C:/Users/sergio.queiroz/OneDrive - Opty/PowerShell-Library/chromedriver.exe')
browser.implicitly_wait(5)

def login(url, user, password):
    # navigating to a webpage
    browser.get(url)
    sleep(10)
    browser.find_element_by_xpath(
        '//*[@id="txtLogin"]').send_keys(user)
    browser.find_element_by_xpath(
        '//*[@id="txtPwd"]').send_keys(password)
    browser.find_element_by_id('ext-gen28').click()

def make_search(category):
    # tree: Minhas tarefas / Pesquisar
    browser.find_element_by_xpath(
        '//*[@id="ext-gen119"]/div/li[2]/ul/li[2]/div/a/span').click()
    # input: Chamado / Categoria
    browser.find_element_by_xpath(
        '/html[1]/body[1]/div[2]/div[3]/div[2]/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[2]/div[1]/div[6]/div[2]/div[1]/div[1]/input[1]').click()
    sleep(5)
    browser.find_element_by_xpath(
        '/html[1]/body[1]/div[2]/div[3]/div[2]/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[2]/div[1]/div[6]/div[2]/div[1]/div[1]/input[1]').send_keys(category)
    # input: Chamado / Todos
    browser.find_element_by_xpath(
        '/html[1]/body[1]/div[2]/div[3]/div[2]/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[2]/div[1]/div[10]/div[1]/div[3]/div[1]/div[1]/div[1]/input[1]').click()
    # button: Procurar
    sleep(5)
    browser.find_element_by_xpath(
        '/html[1]/body[1]/div[2]/div[3]/div[2]/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/div[2]/div[1]/table[1]/tbody[1]/tr[1]/td[1]/table[1]/tbody[1]/tr[1]/td[1]/table[1]/tbody[1]/tr[2]/td[2]/em[1]/button[1]').click()

def delete_data(filepath):
    if os.path.exists(filepath):
        os.remove(filepath)

def export_data():
    sleep(15)
    # button: Exportar
    browser.find_element_by_xpath(
        '/html[1]/body[1]/div[2]/div[3]/div[2]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[2]/div[1]/table[1]/tbody[1]/tr[1]/td[1]/table[1]/tbody[1]/tr[1]/td[12]/table[1]/tbody[1]/tr[2]/td[2]/em[1]').click()
    sleep(20)

def close_browser():
    # make sure the browser stays open for 5sec
    sleep(10)
    # clean exit
    browser.close()

login('https://csi.requestia.com/', 'sergio.queiroz', 'DT1ZC7YqD1Sx')
make_search('Tecnologia da Informação')
delete_data('C:/Users/sergio.queiroz/Downloads/Caixa_de_Entrada.xlsx')
export_data()
close_browser()