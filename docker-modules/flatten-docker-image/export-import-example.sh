# Pull Docker image
docker pull mysql

# List Docker images
docker images

# Run Docker container
docker run 
--name mysql-db 
-e MYSQL_ROOT_PASSWORD=mysql 
-d mysql

# Export Docker container to a tar archive
docker export 
-o mysql-db.tar 
mysql-db

# Import tar archive to a new Docker image
docker import 
mysql-db.tar 
mysql-db:imported
