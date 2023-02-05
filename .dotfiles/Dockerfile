FROM ubuntu

# Set the timezone
ENV TZ Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        ca-certificates \
        git \
        locales-all \
        ssh \
        sudo \
        tmux \
        vim \
        wget

# Configure sudo to allow testing 'agi' (apt-get install) and friends
ADD sudoers /etc/sudoers

# Create a non-root user
RUN useradd \
    --create-home --home-dir /home/test \
    --shell /bin/bash \
    --groups sudo \
    test

# The first time Bash is run, automatically run the config file
RUN echo "[[ ! -d ~/.git ]] && [[ -f ~/dot ]] && cd && . dot" >> /etc/bash.bashrc

# Copy the dot script
COPY dot /root/dot

USER test
COPY dot /home/test/dot

ENV LANG en_GB.UTF-8

# Run Bash when the image is run, starting in the current user's home directory
# (either /root or /home/test depending on the -u option)
WORKDIR /home/test
ENTRYPOINT cd && bash
