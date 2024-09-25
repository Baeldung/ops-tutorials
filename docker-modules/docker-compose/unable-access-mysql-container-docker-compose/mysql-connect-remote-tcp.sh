//Using root user
mysql 
-h 172.17.0.2 
-P 3306 
--protocol=tcp 
-u root 
-p

//Using non-root user
mysql 
-h 172.21.0.2 
-P 3306 
--protocol=tcp 
-u mysql_8_user 
-p
