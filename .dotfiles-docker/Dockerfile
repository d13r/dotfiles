FROM ubuntu

ENV HOME /home/test

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    nano \
    ssh \
    sudo \
    tmux \
    vim \
    wget

# Configure sudo to allow testing 'agi' (apt-get install) and friends
ADD sudoers /etc/sudoers

# Create a non-root test user
RUN useradd --create-home --home-dir $HOME --shell /bin/bash --groups sudo test

# The first time Bash is run, automatically download and run the config file
RUN echo "if [ ! -d ~/.git -a ! -f ~/cfg ]; then cd; wget https://djm.me/cfg; . cfg; fi" >> /etc/bash.bashrc

# Disable the sudo tutorial
USER test
RUN touch $HOME/.sudo_as_admin_successful

# Run Bash when the image is run, starting in the current user's home directory
# (either /root or /home/test depending on the -u option)
WORKDIR /home/test
ENTRYPOINT cd && bash
