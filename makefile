BUILD_COMMAND := docker build --build-arg BASE_IMAGE=python-env --build-arg GID=$(shell id -g) -t dev-container .

image-build:
	$(BUILD_COMMAND)

image-build-no-cache:
	$(BUILD_COMMAND) --no-cache

RUN_COMMAND := docker run -it --name dev-machine --rm -v $(shell pwd):/workdir -w /workdir dev-container  bash

image-run: image-build
	$(RUN_COMMAND)

