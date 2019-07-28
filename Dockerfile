FROM alpine
RUN apk add --no-cache tftp-hpa
VOLUME /var/tftproot
EXPOSE 69/udp
ENTRYPOINT ["in.tftpd"]
CMD ["-L", "--secure", "/var/tftproot"]
