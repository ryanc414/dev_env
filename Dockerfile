# Use Ubuntu as the base image
FROM ubuntu:latest

WORKDIR /root

# Sort out timezone information.
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

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
                       nodejs \
                       npm \
                       valgrind \
                       silversearcher-ag \
                       curl

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
RUN vim +BundleInstall +qall

# Source the zshrc to install antigen plugins.
RUN zsh -c "source ~/.zshrc"

# By default launch a zsh shell.
CMD ["zsh"]

