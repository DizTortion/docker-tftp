REGISTRY=harbor.home.hoffmeister.biz
IMAGE=diztortion/tftp-hpa
REGISTRY_IMAGE=${REGISTRY}/${IMAGE}

PACKAGE_NAME=tftp-hpa

.PHONY: all build push clean clean_all

all: build push clean

build: check-env
	@echo Building ${REGISTRY_IMAGE}:${TAG}
	@docker build --label "org.opencontainers.image.created=$(shell date --rfc-3339=seconds)" --label "org.opencontainers.image.version=$(TAG)" --build-arg TAG=${TAG} --tag ${REGISTRY_IMAGE}:${TAG} .
#	@docker images --filter label=name=${PACKAGE_NAME} --filter label=stage=builder --quiet | xargs --no-run-if-empty docker rmi

push: check-env
	@echo Pushing ${REGISTRY_IMAGE}:${TAG}
	@docker push ${REGISTRY_IMAGE}:${TAG}

clean: check-env
	@docker rmi ${REGISTRY_IMAGE}:${TAG}

clean_all:
	@docker images --filter "reference=${REGISTRY_IMAGE}" --quiet | xargs --no-run-if-empty docker rmi
#	@docker images --filter label=name=${PACKAGE_NAME} --filter label=stage=builder --quiet | xargs --no-run-if-empty docker rmi

check-env:
ifndef TAG
        TAG := $(shell docker run --rm alpine /bin/sh -c "apk update > /dev/null && apk info ${PACKAGE_NAME} | grep \"installed size:\" | sed -E 's/.+-(\d+\.\d+(\.\d+)?-r\d+) installed size:/\1/'")
        $(info TAG is undefined. Using latest release: $(TAG))
endif
