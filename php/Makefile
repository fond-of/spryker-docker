PHP_VERSION ?= 7.3
REGISTRY_HOSTNAME ?= 493499581187.dkr.ecr.eu-central-1.amazonaws.com
IMAGE_NAME ?= fond-of-spryker/php
BASE_DIRECTORY ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

define buildImage
	$(shell sh -c '\
		BUILD_ARGUMENTS="--build-arg REGISTRY=$(REGISTRY_HOSTNAME) --build-arg IMAGE_NAME=$(IMAGE_NAME) ";\
		IMAGE_TAG="$(PHP_VERSION)-$(1)";\
		DOCKER_FILE="$(BASE_DIRECTORY)/$(PHP_VERSION)/$(2)/Dockerfile";\
		\
		if [ "$(2)" == "base" ] && [ "$(1)" == "fpm" ]; then\
			BUILD_ARGUMENTS="";\
		fi;\
		\
		if [ "$(2)" != "base" ]; then\
			IMAGE_TAG="$${IMAGE_TAG}-$(2)";\
		fi;\
		\
		if [ "$(1)" != "fpm" ]; then\
			DOCKER_FILE="$${DOCKER_FILE}.$(1)";\
		fi;\
		\
		if [ ! -d "$(BASE_DIRECTORY)/../logs/build/php/$(PHP_VERSION)" ]; then\
			mkdir -p  $(BASE_DIRECTORY)/../logs/build/php/$(PHP_VERSION);\
		fi;\
		\
		docker build $$BUILD_ARGUMENTS-t $(REGISTRY_HOSTNAME)/$(IMAGE_NAME):$$IMAGE_TAG -f $$DOCKER_FILE $(BASE_DIRECTORY) > $(BASE_DIRECTORY)/../logs/build/php/$(PHP_VERSION)/$(1)-$(2).log; exit 0')
endef

define pushImage
	$(shell sh -c '\
		IMAGE_TAG="$(PHP_VERSION)-$(1)";\
		\
		if [ "$(2)" != "base" ]; then\
			IMAGE_TAG="$${IMAGE_TAG}-$(2)";\
		fi;\
		\
		if [ ! -d "$(BASE_DIRECTORY)/../logs/push/php/$(PHP_VERSION)" ]; then\
			mkdir -p  $(BASE_DIRECTORY)/../logs/push/php/$(PHP_VERSION);\
		fi;\
		\
		docker push $(REGISTRY_HOSTNAME)/$(IMAGE_NAME):$$IMAGE_TAG > $(BASE_DIRECTORY)/../logs/push/php/$(PHP_VERSION)/$(1)-$(2).log; exit 0')
endef

buildImages:
	$(call buildImage,fpm,base)
	$(call buildImage,fpm,dev)
	$(call buildImage,fpm,xdebug)

	$(call buildImage,cli,base)
	$(call buildImage,cli,dev)
	$(call buildImage,cli,xdebug)

	$(call buildImage,jenkins-slave,base)

pushImages:
	$(call pushImage,fpm,base)
	$(call pushImage,fpm,dev)
	$(call pushImage,fpm,xdebug)

	$(call pushImage,cli,base)
	$(call pushImage,cli,dev)
	$(call pushImage,cli,xdebug)

	$(call pushImage,jenkins-slave,base)
