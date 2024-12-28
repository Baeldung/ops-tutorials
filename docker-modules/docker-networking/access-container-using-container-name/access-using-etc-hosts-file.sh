$ docker run 
--name mysql_container 
-e MYSQL_ALLOW_EMPTY_PASSWORD=yes 
mysql:8.4.2

$ docker ps

$ docker inspect

$ vi /etc/hosts
  172.17.0.2 mysql_container

$ mysql 
-h mysql_container 
-P 3306 
--protocol=tcp 
-u root
