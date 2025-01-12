# FROM python-env
ARG BASE_IMAGE=debian:latest
FROM ${BASE_IMAGE}

# install packages
RUN apt-get update && apt upgrade -y
RUN apt-get install -y ripgrep fd-find python3-venv build-essential cmake gettext luarocks unzip wget curl dpkg git

RUN wget -O /tmp/lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/download/v0.44.1/lazygit_0.44.1_Linux_x86_64.tar.gz
RUN tar -xf /tmp/lazygit.tar.gz -C /tmp
RUN install /tmp/lazygit /bin/
RUN rm /tmp/lazygit.tar.gz

# install neovim
RUN git clone https://github.com/neovim/neovim.git /tmp/neovim

RUN make -C /tmp/neovim CMAKE_BUILD_TYPE=RelWithDebInfo -j 10
RUN make -C /tmp/neovim install
RUN rm -rf /tmp/neovim

# Set build arguments for UID and GID
ARG USER_UID=1000
ARG USER_GID=1000
ARG USER_NAME=rafalj
ARG GROUP_NAME=rafalj

# Handle group creation
RUN if getent group ${USER_GID} > /dev/null; then \
        echo "Group with GID ${USER_GID} already exists"; \
    else \
        groupadd --gid ${USER_GID} ${GROUP_NAME}; \
    fi

# Handle user creation
RUN if id -u ${USER_UID} > /dev/null 2>&1; then \
        echo "User with UID ${USER_UID} already exists, deleting..."; \
        userdel -r $(getent passwd ${USER_UID} | cut -d: -f1) || true; \
    fi && \
    useradd --uid ${USER_UID} --gid ${USER_GID} --create-home ${USER_NAME}

# Set working directory and switch to the new user
USER ${USER_NAME}
RUN git clone https://github.com/JasinskiRafal/raj-config-setup.git ~/.config/nvim

# Default command
CMD ["/bin/bash"]
