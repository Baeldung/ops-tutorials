docker run 
--name mysql-container 
-e MYSQL_ROOT_PASSWORD=mysql84-root-pw 
-e MYSQL_DATABASE=test 
-e MYSQL_USER=mysql_8_user 
-e MYSQL_PASSWORD=mysql84-user-pw 
-d 
mysql:8.4.2
