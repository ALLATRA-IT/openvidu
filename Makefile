###############################
# Common defaults/definitions #
###############################

comma := ,

# Checks two given strings for equality.
eq = $(if $(or $(1),$(2)),$(and $(findstring $(1),$(2)),\
                                $(findstring $(2),$(1))),1)




######################
# Project parameters #
######################

IMAGE_NAME := allatra/openvidu-server




###################
# Common commands #
###################

# Builds OpenVidu Server project.
#
# Usage:
#	make build

build:
ifeq ($(wildcard .cache/m2/repository/io/openvidu/openvidu-client),)
	docker run --rm --network=host -v "$(PWD)":/app -w /app \
		-v "$(PWD)"/.cache/m2:/root/.m2 \
		maven:3 \
			mvn -DskipTests=true clean install
endif
	docker run --rm --network=host -v "$(PWD)":/app -w /app/openvidu-server \
		-v "$(PWD)"/.cache/m2:/root/.m2 \
		maven:3 \
			mvn clean compile package


# Builds OpenVidu Server Docker image.
#
# Usage:
#	make image [tag=(dev|<docker-tag>)]

image:
ifeq ($(wildcard openvidu-server/target/openvidu-server-*.jar),)
	@make build
endif
	cd openvidu-server/docker/openvidu-server/ && \
	./create_image.sh $(IMAGE_NAME):$(if $(call eq,$(tag),),dev,$(tag))




##################
# .PHONY section #
##################

.PHONY: build image
