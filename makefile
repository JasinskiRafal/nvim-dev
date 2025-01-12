CLEAN_COMMAND := docker container prune

image-clean:
	$(CLEAN_COMMAND)

BUILD_COMMAND := docker build --build-arg GID=$(shell id -g) -t dev-container .

image-build: image-clean
	$(BUILD_COMMAND)

image-build-no-cache:
	$(BUILD_COMMAND) --no-cache

START_COMMAND := docker run -d -v $(shell pwd):/workspace --name dev-machine dev-container nvim

image-start: image-build
	$(START_COMMAND)

CONNECT_COMMAND := docker exec -it -e "TERM=xterm-256color" dev-machine /bin/bash
image-connect:
	$(CONNECT_COMMAND)


