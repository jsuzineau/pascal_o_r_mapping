import http.client
import json
host='localhost:33007'
url="/angular-test-gICAPI/Data"
requete={'nom_base_de_donnee':"adibat",  'identifiant':'OPE', 'mot_de_passe':'1234'}
hc = http.client.HTTPConnection(host)
hc.request( 'POST',  url,  json.dumps(requete))
r=hc.getresponse()
count=r.read()
print( count)
