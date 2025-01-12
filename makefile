DEV_IMAGE := dev-image
DEV_CONTAINER := dev-container

env-clean:
	docker container prune

BUILD_COMMAND := docker build \
		 --build-arg USER_UID=$(shell id -u) \
		 --build-arg USER_GID=$(shell id -g) \
		 --build-arg USER_NAME=rafalj \
		 --build-arg GROUP_NAME=rafalj \
		 -t $(DEV_CONTAINER) .

env-build: env-clean
	$(BUILD_COMMAND)

env-build-no-cache:
	$(BUILD_COMMAND) --no-cache

env-start: env-build
	docker run -d \
		-v $(shell pwd):/workspace:rw \
		-v ~/.ssh:/home/rafalj/.ssh:ro \
		--name $(DEV_CONTAINER) $(DEV_CONTAINER) \
		tail -f /dev/null && \
	docker exec -w /home/rafalj $(DEV_CONTAINER) \
		git clone git@github.com:JasinskiRafal/raj-config-setup.git .config/nvim


env-stop:
	docker container kill $(DEV_CONTAINER)

env-connect:
	docker exec -it \
		-e "TERM=xterm-256color" \
		-w /workspace $(DEV_CONTAINER) \
		/bin/bash

