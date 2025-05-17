# Docker save
docker save mysql:latest | gzip > mysql.tar.gz

# Docker load
docker load < mysql.tar.gz
