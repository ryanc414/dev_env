# Use Ubuntu as the base image
FROM ubuntu:latest

WORKDIR /root

# Sort out timezone information.
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Do not exclude man pages & other documentation
RUN rm /etc/dpkg/dpkg.cfg.d/excludes

# Reinstall all currently installed packages in order to get the man pages back
RUN apt-get update && \
    dpkg -l | grep ^ii | cut -d' ' -f3 | xargs apt-get install -y --reinstall && \
        rm -r /var/lib/apt/lists/*

# Install extra packages.
RUN apt-get update && \
    apt-get install -y tmux \
                       zsh \
                       unzip \
                       vim-nox \
                       less \
                       git \
                       wget \
                       gcc \
                       g++ \
                       gdb \
                       make \
                       python \
                       python-pip \
                       python-dev \
                       python3.7 \
                       python3-pip \
                       python3.7-dev \
                       valgrind \
                       silversearcher-ag \
                       curl \
                       python3.7-venv \
                       software-properties-common

# Install latest Go
RUN add-apt-repository ppa:longsleep/golang-backports && \
    apt-get install -y golang-go

# Set up python virtual environments
RUN mkdir ~/.venv && \
    python3.7 -m venv ~/.venv/py37 && \
    python2 -m pip install virtualenv && \
    python2 -m virtualenv ~/.venv/py2

# Install latest version of nodejs
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install nodejs

# Set up development environment. Install dotfiles.
RUN git clone -b master https://github.com/ryanc414/dotfiles.git .dotfiles && .dotfiles/install

# Install exa
RUN wget https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip && \
    unzip exa*.zip -d /bin && \
    ln -s /bin/exa-linux-x86_64 /bin/exa && \
    rm exa*.zip

# Install fd
RUN wget https://github.com/sharkdp/fd/releases/download/v7.1.0/fd-musl_7.1.0_amd64.deb && \
    dpkg -i fd-musl_7.1.0_amd64.deb && \
    rm fd-musl_7.1.0_amd64.deb

# Install fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

# Install vim plugins
RUN vim +BundleInstall +GoInstallBinaries +qall

# Source the zshrc to install antigen plugins.
RUN zsh -c "source ~/.zshrc"

# By default launch a zsh shell.
CMD ["zsh"]

