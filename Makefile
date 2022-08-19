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
TAG := $(shell \
        curl --silent https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/x86_64/APKINDEX.tar.gz --output - | \
        tar --extract --gunzip --to-stdout "APKINDEX" | \
        grep --perl-regexp --only-matching --null-data "P:${PACKAGE_NAME}\nV:\K([^\n]+)")
        $(info TAG is undefined. Using latest release: $(TAG))
endif
