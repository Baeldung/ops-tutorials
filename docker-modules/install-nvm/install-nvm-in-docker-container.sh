docker run 
-it 
--name ubuntu-demo 
ubuntu 
/bin/bash -c "echo 'Hello World'; /bin/bash"

#The following commands are to be run within the container
apt update && apt install curl -y

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] &amp;&amp; \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] &amp;&amp; \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install node

nvm current
