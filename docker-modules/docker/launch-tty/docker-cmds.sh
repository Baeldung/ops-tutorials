$ docker run 
--name mysql 
-it 
-e MYSQL_ALLOW_EMPTY_PASSWORD=yes 
mysql:8.4 bash

$ docker run 
--name mysql 
-e MYSQL_ALLOW_EMPTY_PASSWORD=yes 
-d 
mysql:8.4

$ docker exec 
-it 
mysql  
bash

$ docker run 
--name ubuntu-demo 
ubuntu 
echo "Hello World"

$ docker run 
-d 
--name ubuntu-demo 
ubuntu 
/bin/bash 
-c "echo 'Hello World'; sleep 10000"

$ docker exec 
-it 
ubuntu-demo  
bash

$ docker run 
-it 
--name ubuntu-demo 
ubuntu 
/bin/bash 
-c "echo 'Hello World'; /bin/bash"

$ docker run 
-it
--name ubuntu-demo 
ubuntu 
/bin/bash 
-c "echo 'Hello World'; cat"

$ docker run 
-it 
--name ubuntu-demo 
ubuntu 
/bin/bash 
-c "echo 'Hello World'; tail -f /dev/null"

$ docker run 
-it 
mcr.microsoft.com/windows/nanoserver:ltsc2022 
cmd.exe
