PHP_VERSION ?= 7.3
REGISTRY_HOSTNAME ?= 493499581187.dkr.ecr.eu-central-1.amazonaws.com
IMAGE_NAME ?= fond-of-spryker/php
BASE_DIRECTORY ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
TEST_MODE ?= 1

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
			DOCKER_FILE="$(BASE_DIRECTORY)/$(PHP_VERSION)/$(2)/$(1).Dockerfile";\
		fi;\
		\
		if [ ! -d "$(BASE_DIRECTORY)/../logs/build/php/$(PHP_VERSION)" ]; then\
			mkdir -p  $(BASE_DIRECTORY)/../logs/build/php/$(PHP_VERSION);\
		fi;\
		\
		docker build $$BUILD_ARGUMENTS-t $(REGISTRY_HOSTNAME)/$(IMAGE_NAME):$$IMAGE_TAG -f $$DOCKER_FILE $(BASE_DIRECTORY) > $(BASE_DIRECTORY)/../logs/build/php/$(PHP_VERSION)/$(1)-$(2).log;\
		\
		exit 0;\
	')
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
		if [ "$(2)" == "base" ] && [ "$(TEST_MODE)" == "1" ]; then\
			docker tag $(REGISTRY_HOSTNAME)/$(IMAGE_NAME):$$IMAGE_TAG $(REGISTRY_HOSTNAME)/$(IMAGE_NAME):$${IMAGE_TAG}-staging > $(BASE_DIRECTORY)/../logs/push/php/$(PHP_VERSION)/$(1)-$(2).log;\
			docker push $(REGISTRY_HOSTNAME)/$(IMAGE_NAME):$${IMAGE_TAG}-staging >> $(BASE_DIRECTORY)/../logs/push/php/$(PHP_VERSION)/$(1)-$(2).log;\
		else\
			docker push $(REGISTRY_HOSTNAME)/$(IMAGE_NAME):$$IMAGE_TAG > $(BASE_DIRECTORY)/../logs/push/php/$(PHP_VERSION)/$(1)-$(2).log;\
		fi;\
		\
		exit 0;\
	')
endef

.PHONY: buildFpmBaseImage
buildFpmBaseImage:
	$(call buildImage,fpm,base)

.PHONY: buildFpmDevImage
buildFpmDevImage:
	$(call buildImage,fpm,dev)

.PHONY: buildFpmXdebugImage
buildFpmXdebugImage:
	$(call buildImage,fpm,xdebug)

.PHONY: buildFpmProductionImage
buildFpmProductionImage:
	$(call buildImage,fpm,production)

.PHONY: buildCliBaseImage
buildCliBaseImage:
	$(call buildImage,cli,base)

.PHONY: buildCliDevImage
buildCliDevImage:
	$(call buildImage,cli,dev)

.PHONY: buildCliXdebugImage
buildCliXdebugImage:
	$(call buildImage,cli,xdebug)

.PHONY: buildCliProductionImage
buildCliProductionImage:
	$(call buildImage,cli,production)

.PHONY: buildJenkinsSlaveBaseImage
buildJenkinsSlaveBaseImage:
	$(call buildImage,jenkins-slave,base)

.PHONY: buildJenkinsSlaveProductionImage
buildJenkinsSlaveProductionImage:
	$(call buildImage,jenkins-slave,production)

.PHONY: buildFpmImages
buildFpmImages: buildFpmBaseImage buildFpmDevImage buildFpmXdebugImage buildFpmProductionImage

.PHONY: buildCliImages
buildCliImages: buildCliBaseImage buildCliDevImage buildCliXdebugImage buildCliProductionImage

.PHONY: buildJenkinsSlaveImages
buildJenkinsSlaveImages: buildJenkinsSlaveBaseImage buildJenkinsSlaveProductionImage

.PHONY: buildImages
buildImages: buildFpmImages buildCliImages buildJenkinsSlaveImages

.PHONY: pushFpmBaseImage
pushFpmBaseImage:
	$(call pushImage,fpm,base)

.PHONY: pushFpmDevImage
pushFpmDevImage:
	$(call pushImage,fpm,dev)

.PHONY: pushFpmXdebugImage
pushFpmXdebugImage:
	$(call pushImage,fpm,xdebug)

.PHONY: pushFpmProductionImage
pushFpmProductionImage:
	$(call pushImage,fpm,production)

.PHONY: pushCliBaseImage
pushCliBaseImage:
	$(call pushImage,cli,base)

.PHONY: pushCliDevImage
pushCliDevImage:
	$(call pushImage,cli,dev)

.PHONY: pushCliXdebugImage
pushCliXdebugImage:
	$(call pushImage,cli,xdebug)

.PHONY: pushCliProductionImage
pushCliProductionImage:
	$(call pushImage,cli,production)

.PHONY: pushJenkinsSlaveBaseImage
pushJenkinsSlaveBaseImage:
	$(call pushImage,jenkins-slave,base)

.PHONY: pushJenkinsSlaveProductionImage
pushJenkinsSlaveProductionImage:
	$(call pushImage,jenkins-slave,production)

.PHONY: pushFpmImages
pushFpmImages: pushFpmBaseImage pushFpmDevImage pushFpmXdebugImage pushFpmProductionImage

.PHONY: pushCliImages
pushCliImages: pushCliBaseImage pushCliDevImage pushCliXdebugImage pushCliProductionImage

.PHONY: pushJenkinsSlaveImages
pushJenkinsSlaveImages: pushJenkinsSlaveBaseImage pushJenkinsSlaveProductionImage

.PHONY: pushImages
pushImages: pushFpmImages pushCliImages pushJenkinsSlaveImages
