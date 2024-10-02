import http.client
import json
host='localhost:58197'
url="/Work_Set2"
blWork={"id":"2","Selected":"","nUser":"0","nProject":"1","Beginning":"2015-07-01 20:55","End":"2015-07-01 23:00","Description":"test python","Duree":"02:04","Session_Titre":"02:04:","sSession":"02:04:"}
hc = http.client.HTTPConnection(host)
hc.request( 'POST',  url,  json.dumps(blWork))
r=hc.getresponse()
Resultat=r.read()
print( Resultat)
