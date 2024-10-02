$blWork = '{"id":"2","Selected":"","nUser":"0","nProject":"1","Beginning":"2015-07-01 20:55","End":"2015-07-01 23:00","Description":"test Windows PowerShell","Duree":"02:04","Session_Titre":"02:04:","sSession":"02:04:"}'
$Resultat = Invoke-WebRequest -UseBasicParsing 'http://localhost:51907/Work_Set2' -Body $blWork -Method 'POST'
Write-Host $Resultat