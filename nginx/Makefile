NGINX_VERSION ?= 1.16
REGISTRY_HOSTNAME ?= 493499581187.dkr.ecr.eu-central-1.amazonaws.com
IMAGE_NAME ?= fond-of-spryker/nginx
BASE_DIRECTORY ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

define buildImage
	$(shell sh -c '\
		BUILD_ARGUMENTS="";\
		IMAGE_TAG="$(NGINX_VERSION)-$(1)";\
		DOCKER_FILE="$(BASE_DIRECTORY)/$(NGINX_VERSION)/$(2)/Dockerfile";\
		\
		if [ "$(2)" != "base" ]; then\
			BUILD_ARGUMENTS="--build-arg REGISTRY=$(REGISTRY_HOSTNAME) --build-arg IMAGE_NAME=$(IMAGE_NAME) ";\
			IMAGE_TAG="$${IMAGE_TAG}-$(2)";\
		fi;\
		\
		if [ ! -d "$(BASE_DIRECTORY)/../logs/build/nginx/$(NGINX_VERSION)" ]; then\
			mkdir -p  $(BASE_DIRECTORY)/../logs/build/nginx/$(NGINX_VERSION);\
		fi;\
		\
		docker build --build-arg APPLICATION=$(1) $$BUILD_ARGUMENTS-t $(REGISTRY_HOSTNAME)/$(IMAGE_NAME):$$IMAGE_TAG -f $$DOCKER_FILE $(BASE_DIRECTORY) > $(BASE_DIRECTORY)/../logs/build/nginx/$(NGINX_VERSION)/$(1)-$(2).log;\
		\
		exit 0;\
	')
endef

define pushImage
	$(shell sh -c '\
		IMAGE_TAG="$(NGINX_VERSION)-$(1)";\
		\
		if [ "$(2)" != "base" ]; then\
			IMAGE_TAG="$${IMAGE_TAG}-$(2)";\
		fi;\
		\
		if [ ! -d "$(BASE_DIRECTORY)/../logs/push/nginx/$(NGINX_VERSION)" ]; then\
			mkdir -p  $(BASE_DIRECTORY)/../logs/push/nginx/$(NGINX_VERSION);\
		fi;\
		\
		docker push $(REGISTRY_HOSTNAME)/$(IMAGE_NAME):$$IMAGE_TAG > $(BASE_DIRECTORY)/../logs/push/nginx/$(NGINX_VERSION)/$(1)-$(2).log;\
		\
		exit 0;\
	')
endef

.PHONY: buildImages
buildImages:
	$(call buildImage,yves,base)
	$(call buildImage,glue,base)
	$(call buildImage,zed,base)

	$(call buildImage,yves,xdebug)
	$(call buildImage,glue,xdebug)
	$(call buildImage,zed,xdebug)

.PHONY: pushImages
pushImages:
	$(call pushImage,yves,base)
	$(call pushImage,glue,base)
	$(call pushImage,zed,base)

	$(call pushImage,yves,xdebug)
	$(call pushImage,glue,xdebug)
	$(call pushImage,zed,xdebug)
