BASE_DIRECTORY ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PHP_VERSIONS ?= 7.2 7.3
NGINX_VERSIONS ?= 1.16
REGISTRY_HOSTNAME ?= 493499581187.dkr.ecr.eu-central-1.amazonaws.com
PHP_IMAGE_NAME ?= fond-of-spryker/php
NGINX_IMAGE_NAME ?= fond-of-spryker/nginx
MAILCATCHER_IMAGE_NAME ?= fond-of-spryker/mailcatcher

define buildPhpImagesForGivenVersion
	$(shell make -s -f $(BASE_DIRECTORY)/php/Makefile PHP_VERSION=$(1) IMAGE_NAME=$(PHP_IMAGE_NAME) REGISTRY_HOSTNAME=$(REGISTRY_HOSTNAME) buildImages)
endef

define buildNginxImagesForGivenVersion
	$(shell make -s -f $(BASE_DIRECTORY)/nginx/Makefile NGINX_VERSION=$(1) IMAGE_NAME=$(NGINX_IMAGE_NAME) REGISTRY_HOSTNAME=$(REGISTRY_HOSTNAME) buildImages)
endef

define pushPhpImagesForGivenVersion
	$(shell make -s -f $(BASE_DIRECTORY)/php/Makefile PHP_VERSION=$(1) IMAGE_NAME=$(PHP_IMAGE_NAME) REGISTRY_HOSTNAME=$(REGISTRY_HOSTNAME) pushImages)
endef

define pushNginxImagesForGivenVersion
	$(shell make -s -f $(BASE_DIRECTORY)/nginx/Makefile NGINX_VERSION=$(1) IMAGE_NAME=$(NGINX_IMAGE_NAME) REGISTRY_HOSTNAME=$(REGISTRY_HOSTNAME) pushImages)
endef

buildAllPhpImages:
	$(foreach PHP_VERSION,$(PHP_VERSIONS),$(call buildPhpImagesForGivenVersion,$(PHP_VERSION)))

buildAllNginxImages:
	$(foreach NGINX_VERSION,$(NGINX_VERSIONS),$(call buildNginxImagesForGivenVersion,$(NGINX_VERSION)))

buildAllMailcatcherImages:
	$(shell make -s -f $(BASE_DIRECTORY)/mailcatcher/Makefile IMAGE_NAME=$(MAILCATCHER_IMAGE_NAME) REGISTRY_HOSTNAME=$(REGISTRY_HOSTNAME) buildImages)

buildAllImages: buildAllPhpImages buildAllNginxImages buildAllMailcatcherImages;

pushAllPhpImages:
	$(foreach PHP_VERSION,$(PHP_VERSIONS),$(call pushPhpImagesForGivenVersion,$(PHP_VERSION)))

pushAllNginxImages:
	$(foreach NGINX_VERSION,$(NGINX_VERSIONS),$(call pushNginxImagesForGivenVersion,$(NGINX_VERSION)))

pushAllMailcatcherImages:
	$(shell make -s -f $(BASE_DIRECTORY)/mailcatcher/Makefile IMAGE_NAME=$(MAILCATCHER_IMAGE_NAME) REGISTRY_HOSTNAME=$(REGISTRY_HOSTNAME) pushImages)

pushAllImages: pushAllPhpImages pushAllNginxImages pushAllMailcatcherImages