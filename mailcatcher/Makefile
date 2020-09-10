REGISTRY_HOSTNAME ?= 493499581187.dkr.ecr.eu-central-1.amazonaws.com
IMAGE_NAME ?= fond-of-spryker/mailcatcher
BASE_DIRECTORY ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

define buildImage
	$(shell sh -c '\
		if [ ! -d "$(BASE_DIRECTORY)/../logs/build/mailcatcher/1.0.0" ]; then\
			mkdir -p  $(BASE_DIRECTORY)/../logs/build/mailcatcher/1.0.0;\
		fi;\
		\
		docker build -t $(REGISTRY_HOSTNAME)/$(IMAGE_NAME):1.0.0 $(BASE_DIRECTORY) > $(BASE_DIRECTORY)/../logs/build/mailcatcher/1.0.0/base.log;\
		\
		exit 0;\
	')
endef

define pushImage
	$(shell sh -c '\
		if [ ! -d "$(BASE_DIRECTORY)/../logs/push/mailcatcher/1.0.0" ]; then\
			mkdir -p  $(BASE_DIRECTORY)/../logs/push/mailcatcher/1.0.0;\
		fi;\
		\
		docker push $(REGISTRY_HOSTNAME)/$(IMAGE_NAME):1.0.0 > $(BASE_DIRECTORY)/../logs/push/mailcatcher/1.0.0/base.log;\
		\
		exit 0;\
	')
endef

buildImages:
	$(call buildImage)

pushImages:
	$(call pushImage)
