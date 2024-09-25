docker inspect 
-f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 
mysql-container --Replace with container name
