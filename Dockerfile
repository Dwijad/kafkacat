ARG DOCKER_UPSTREAM_REGISTRY=
ARG DOCKER_UPSTREAM_TAG=ubi8-latest
ARG PROJECT_VERSION
ARG ARTIFACT_ID
ARG GIT_COMMIT

FROM confluentinc/cp-base-new:latest-ubi8

WORKDIR /build

ENV VERSION=1.7.0
ENV BUILD_PACKAGES="which git make cmake gcc-c++ zlib-devel curl curl-devel openssl-devel cyrus-sasl-devel pkgconfig lz4-devel wget tar findutils"

USER root

RUN echo "Building kcat ....." \
    && dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && dnf install -y $BUILD_PACKAGES \
    && dnf clean all \
    && git clone https://github.com/edenhill/kcat \
    && cd kcat \
    && git checkout $VERSION \
    && ./bootstrap.sh \
    && make \
    && ldd kcat

FROM confluentinc/cp-base-new:latest-ubi8

LABEL maintainer="dwijad"
LABEL summary="kcat is a command line utility that you can use to test and debug Apache Kafka® deployments. You can use kcat to produce, consume, and list topic and partition information for Kafka. Described as “netcat for Kafka”, it is a swiss-army knife of tools for inspecting and creating data in Kafka."


USER root

COPY --from=0 /build/kcat/kcat /usr/local/bin/

RUN ln -s /usr/local/bin/kcat /usr/local/bin/kafkacat \
    && echo "Installing runtime dependencies for SSL and SASL support ...." \
    && microdnf install dnf \
    && dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && dnf install -y ca-certificates \
    && echo "===> clean up ..."  \
    && dnf clean all \
    && rm -rf /tmp/*

USER appuser

RUN kcat -V

ENTRYPOINT ["kcat"]
