ARG base=ubuntu

#===============================================================================
# Debian-based OS (inc. Ubuntu)
#===============================================================================
FROM ${base} AS debian

ENV LANG en_GB.UTF-8
ENV TZ Europe/London

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        git \
        ssh \
        sudo \
        tmux \
        vim

# Configure sudo to allow testing 'agi' (apt-get install) and friends
ADD sudoers /etc/sudoers.d/test

# Create a non-root user
RUN useradd --create-home --shell=/bin/bash test

# The first time Bash is run, automatically run the setup script
RUN echo "[[ ! -d ~/.git ]] && [[ -f ~/dot ]] && cd && . dot" >> /etc/bash.bashrc

# Copy the setup script to each user account
COPY dot /root/dot

USER test
COPY dot /home/test/dot

#===============================================================================
# Red Hat-based OS
#===============================================================================
FROM ${base} AS redhat

ENV LANG en_GB.UTF-8
ENV TZ Europe/London

# Install dependencies
RUN yum install -y \
    git \
    tmux \
    vim

## Configure sudo to allow testing 'agi' (apt-get install) and friends
ADD sudoers /etc/sudoers.d/test

# Create a non-root user
RUN useradd test

# The first time Bash is run, automatically run the setup script
RUN echo "[[ ! -d ~/.git ]] && [[ -f ~/dot ]] && cd && . dot" >> /etc/bashrc

# Copy the setup script to each user account
COPY dot /root/dot

USER test
COPY dot /home/test/dot

#===============================================================================
# Alpine
#===============================================================================
FROM ${base} AS alpine

ENV LANG en_GB.UTF-8
ENV TZ Europe/London

# Install dependencies
RUN apk update && apk add \
    bash \
    git \
    openssh \
    shadow \
    sudo \
    tmux \
    vim

# Configure sudo to allow testing 'agi' (apt-get install) and friends
ADD sudoers /etc/sudoers.d/test

# Change the default root shell from ash to bash
RUN chsh root -s /bin/bash

# Create a non-root user
RUN adduser --disabled-password --shell=/bin/bash test

# The first time Bash is run, automatically run the setup script
RUN echo "[[ ! -d ~/.git ]] && [[ -f ~/dot ]] && cd && . dot" >> /etc/bash/bashrc

# Copy the setup script to each user account
COPY dot /root/dot

USER test
COPY dot /home/test/dot
