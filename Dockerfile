# FROM python-env
ARG BASE_IMAGE=ubuntu:latest
FROM ${BASE_IMAGE}

# install packages
RUN apt update && apt upgrade
RUN apt install -y ripgrep fd-find python3-venv build-essential cmake gettext luarocks unzip wget curl dpkg git

RUN wget -O /tmp/lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/download/v0.44.1/lazygit_0.44.1_Linux_x86_64.tar.gz
RUN tar -xf /tmp/lazygit.tar.gz -C /tmp
RUN install /tmp/lazygit /bin/
RUN rm /tmp/lazygit.tar.gz

# install neovim
RUN git clone https://github.com/neovim/neovim.git /tmp/neovim

RUN make -C /tmp/neovim CMAKE_BUILD_TYPE=RelWithDebInfo -j 10
RUN make -C /tmp/neovim install
RUN rm -rf /tmp/neovim

# create new user and group
RUN groupadd devcontainer
RUN useradd --create-home --groups devcontainer,root rafalj

# log in as the created user and use it for development
USER rafalj
RUN git clone https://github.com/JasinskiRafal/raj-config-setup.git ~/.config/nvim

