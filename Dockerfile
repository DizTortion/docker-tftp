FROM docker.io/library/alpine

ARG TAG

RUN if [ -z ${TAG} ]; then apk add --no-cache tftp-hpa; else apk add --no-cache tftp-hpa=$TAG; fi

VOLUME /var/tftproot

EXPOSE 69/udp

ENTRYPOINT ["in.tftpd"]

CMD ["-L", "--secure", "/var/tftproot"]
