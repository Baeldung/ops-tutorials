# Downloading and Installing Apache Tomcat

wget https://downloads.apache.org/tomcat/tomcat-11/v11.0.1/bin/apache-tomcat-11.0.1.tar.gz

tar -xvzf apache-tomcat-11.0.1.tar.gz

# Setting Up a Dedicated Tomcat User

sudo useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat

sudo mv apache-tomcat-11.0.1 /opt/tomcat

sudo ln -s /opt/tomcat/apache-tomcat-11.0.1 /opt/tomcat/updated

sudo chown -R tomcat: /opt/tomcat/*

sudo sh -c 'chmod +x /opt/tomcat/updated/bin/*.sh'


# Configuring Tomcat as a Service

sudo nano /etc/systemd/system/tomcat.service

sudo systemctl daemon-reload

sudo systemctl start tomcat

sudo systemctl status tomcat

sudo systemctl enable tomcat