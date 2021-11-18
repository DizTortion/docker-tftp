FROM alpine

ARG TAG

RUN if [ -z ${TAG} ]; then apk add --no-cache samba; else apk add --no-cache samba=$TAG; fi

VOLUME /var/tftproot

EXPOSE 69/udp

ENTRYPOINT ["in.tftpd"]

CMD ["-L", "--secure", "/var/tftproot"]
