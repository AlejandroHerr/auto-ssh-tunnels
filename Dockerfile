# setup build arguments for version of dependencies to use
ARG DOCKER_GEN_VERSION=0.7.7

# Use a specific version of golang to build both binaries
FROM golang:1.16.6 as gobuilder

# Build docker-gen from scratch
FROM gobuilder as dockergen

ARG DOCKER_GEN_VERSION

RUN git clone https://github.com/jwilder/docker-gen \
  && cd /go/docker-gen \
  && git -c advice.detachedHead=false checkout $DOCKER_GEN_VERSION \
  && go mod download \
  && CGO_ENABLED=0 GOOS=linux go build -ldflags "-X main.buildVersion=${DOCKER_GEN_VERSION}" ./cmd/docker-gen \
  && go clean -cache \
  && mv docker-gen /usr/local/bin/ \
  && cd - \
  && rm -rf /go/docker-gen


FROM alpine:3

LABEL maintainer="Alejandro Hernández <hola@alejandroherr.io"

RUN apk update && apk add --no-cache \ 
  openssh \
  autossh \
  parallel \
  bash

RUN mkdir /ssh
RUN mkdir /logs

COPY ./entrypoint.sh /entrypoint.sh
COPY ./docker-gen.cfg /docker-gen.cfg
COPY ./tunneler.tmpl /tunneler.tmpl
COPY ./startTunnels.sh /startTunnels.sh
COPY --from=dockergen /usr/local/bin/docker-gen /usr/local/bin/docker-gen


ENTRYPOINT ["/bin/bash", "/entrypoint.sh" ]

