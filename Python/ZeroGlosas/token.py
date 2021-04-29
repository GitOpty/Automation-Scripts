import requests
from requests.auth import HTTPBasicAuth

# GERAÇÃO TOKEN
response = requests.get("https://accounts-cloud.zeroglosa.com.br/auth/token?expirationMillis=120000",auth=HTTPBasicAuth('grupoopty','grupoopty'))

url_zero_glosas = "https://datasource-service-cloud.zeroglosa.com.br/api/results/"

token = response.text.split(":")
itoken = [x.replace('"','') for x in token]
token = 'Bearer ' + itoken[1]
token = token.split(",")


headers = {
     'Authorization': token[0],
     'Content-Type': 'application/json'
}

id_consulta = '3530745'
consulta = {
    "max":0,
    "offset":0
}

url_used = url_zero_glosas + id_consulta + '/1'

resp = requests.get(url=url_used, params=consulta, headers=headers)


resp.json()

print(resp.status_code)

