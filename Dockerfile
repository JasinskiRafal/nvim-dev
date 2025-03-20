# setup the base image, in case you have your env created elsewhere
ARG BASE_IMAGE=debian:latest
FROM ${BASE_IMAGE}

# root section
# install packages
RUN apt-get update -y
RUN apt-get install -y ripgrep fd-find python3-venv build-essential cmake gettext luarocks unzip wget curl dpkg git

# install neovim
RUN git clone https://github.com/neovim/neovim.git /tmp/neovim

RUN make -C /tmp/neovim CMAKE_BUILD_TYPE=RelWithDebInfo -j 10
RUN make -C /tmp/neovim install
RUN rm -rf /tmp/neovim

# user section
# Set build arguments for UID and GID
ARG USER_UID=1000
ARG USER_GID=1000

# Handle group creation
RUN if getent group ${USER_GID} > /dev/null; then \
        echo "Group with GID ${USER_GID} already exists"; \
    else \
        groupadd --gid ${USER_GID} dev; \
    fi

# Handle user creation
RUN if id -u ${USER_UID} > /dev/null 2>&1; then \
        echo "User with UID ${USER_UID} already exists, deleting..."; \
        userdel -r $(getent passwd ${USER_UID} | cut -d: -f1) || true; \
    fi && \
    useradd --uid ${USER_UID} --gid ${USER_GID} --create-home rafalj

# Set working directory and switch to the new user
USER rafalj

COPY config/ /home/rafalj/.config/nvim
RUN nvim --headless -c "Lazy! sync" -c qa
RUN nvim --headless -c "TSInstall all" -c qa
RUN nvim --headless -c "MasonToolsInstallSync" -c qa
