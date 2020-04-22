FROM ubuntu

ENV HOME /home/dave

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

# Create a non-root user
RUN useradd --create-home --home-dir $HOME --shell /bin/bash --groups sudo dave

# The first time Bash is run, automatically run the config file
RUN echo "[ ! -d ~/.git ] && cd && wget djm.me/cfg && . cfg" >> /etc/bash.bashrc

# Disable the sudo tutorial
USER dave
RUN touch $HOME/.sudo_as_admin_successful

# Run Bash when the image is run, starting in the current user's home directory
# (either /root or /home/dave depending on the -u option)
USER dave
WORKDIR /home/dave
ENTRYPOINT cd && bash
