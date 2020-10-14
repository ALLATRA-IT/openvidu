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

IMAGE_REPO := allatra




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
#	make image [app=(server|recording)] [tag=(dev|<docker-tag>)]

image-app = $(if $(call eq,$(app),),server,$(app))
image-tag = $(if $(call eq,$(tag),),dev,$(tag))

image:
ifeq ($(wildcard openvidu-server/target/openvidu-server-*.jar),)
	@make build
endif
ifeq ($(image-app),server)
	cd openvidu-server/docker/openvidu-server/ && \
	./create_image.sh $(IMAGE_REPO)/openvidu-server:$(image-tag)
else
ifeq ($(image-app),recording)
	cd openvidu-server/docker/openvidu-recording/ && \
	./create_image.sh \
		ubuntu-16-04 86.0.4240.75-1 $(IMAGE_REPO)/openvidu-recording:$(image-tag)
endif
endif




##################
# .PHONY section #
##################

.PHONY: build image
