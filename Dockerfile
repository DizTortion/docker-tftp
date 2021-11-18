FROM alpine

ARG TAG

RUN apk add --no-cache tftp-hpa=$TAG

VOLUME /var/tftproot

EXPOSE 69/udp

ENTRYPOINT ["in.tftpd"]

CMD ["-L", "--secure", "/var/tftproot"]
