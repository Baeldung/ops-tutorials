FROM ubuntu:latest
ARG NODE_VERSION=20

# install curl
RUN apt update &amp;&amp; apt install curl -y

# install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

# set env
ENV NVM_DIR=/root/.nvm

# install node
RUN bash -c "source $NVM_DIR/nvm.sh &amp;&amp; nvm install $NODE_VERSION"

# set ENTRYPOINT for reloading nvm-environment
ENTRYPOINT ["bash", "-c", "source $NVM_DIR/nvm.sh &amp;&amp; exec \"$@\"", "--"]

# set cmd to bash
CMD ["/bin/bash"]
