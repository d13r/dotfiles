FROM ubuntu

# Set the timezone
ENV TZ Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        git \
        ssh \
        sudo \
        tmux \
        vim \
        wget

# Configure sudo to allow testing 'agi' (apt-get install) and friends
ADD sudoers /etc/sudoers

# Create a non-root user
RUN useradd \
    --create-home --home-dir /home/dave \
    --shell /bin/bash \
    --groups sudo \
    dave

# The first time Bash is run, automatically run the config file
RUN echo "[ ! -d ~/.git ] && cd && wget djm.me/cfg && . cfg" >> /etc/bash.bashrc

# Run Bash when the image is run, starting in the current user's home directory
# (either /root or /home/dave depending on the -u option)
USER dave
WORKDIR /home/dave
ENTRYPOINT cd && bash
