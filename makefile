DEV_IMAGE := dev-image
DEV_CONTAINER := dev-container

env-clean:
	docker container prune

BUILD_COMMAND := docker build --build-arg USER_UID=$(shell id -u) --build-arg USER_GID=$(shell id -g) -t $(DEV_CONTAINER) .

env-build: env-clean
	$(BUILD_COMMAND)

env-build-no-cache:
	$(BUILD_COMMAND) --no-cache

env-start: env-build
	docker run -d -v $(shell pwd):/workspace:rw --name $(DEV_CONTAINER) $(DEV_CONTAINER) tail -f /dev/null

env-stop:
	docker container kill $(DEV_CONTAINER)

env-connect:
	docker exec -it -e "TERM=xterm-256color" -w /workspace $(DEV_CONTAINER) /bin/bash

