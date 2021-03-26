FROM php:7-fpm AS goeleven

RUN apt-get update \
    && apt-get install -y --no-install-recommends libccid opensc softhsm2 libltdl-dev p11-kit golang-go \
    && rm -rf /var/lib/apt/lists/*

ADD https://github.com/tenet-ac-za/goeleven/archive/master.tar.gz /opt/
RUN tar -xf /opt/master.tar.gz -C /opt \
    && mv /opt/goeleven-master /opt/goeleven \
    && rm -rf /opt/master.tar.gz
ADD https://github.com/wayf-dk/pkcs11/archive/master.tar.gz /opt/goeleven/src/vendor/github.com/wayf-dk/
RUN tar -xf /opt/goeleven/src/vendor/github.com/wayf-dk/master.tar.gz -C /opt/goeleven/src/vendor/github.com/wayf-dk \
    && mv /opt/goeleven/src/vendor/github.com/wayf-dk/pkcs11-master /opt/goeleven/src/vendor/github.com/wayf-dk/pkcs11 \
    && rm -rf /opt/goeleven/src/vendor/github.com/wayf-dk/master.tar.gz

ENV GOPATH=/opt/goeleven
WORKDIR /opt/goeleven
RUN go build src/goeleven/goeleven.go

COPY entrypoint.sh /

EXPOSE 8080/tcp

ENTRYPOINT /entrypoint.sh