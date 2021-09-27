FROM alpine:3.14

RUN apk add --no-cache bash tzdata curl imagemagick && \
    ln -snf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime && echo Europe/Warsaw > /etc/timezone

WORKDIR /pb-rozklad
COPY . .

USER 1000:1000
VOLUME ["/data"]

CMD ["/bin/bash", "main.sh", "/data/config.txt"]