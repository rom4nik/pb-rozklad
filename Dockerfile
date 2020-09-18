FROM alpine:3.12

RUN apk add --no-cache bash tzdata curl imagemagick python3 && \
    python3 -m ensurepip && \
    pip3 install --no-cache fbchat pyotp && \
    ln -snf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime && echo Europe/Warsaw > /etc/timezone

WORKDIR /pb-rozklad
COPY . .

USER 1000:1000
VOLUME ["/data"]

ENV DOCKER=true
CMD ["/bin/bash", "main.sh", "/data/config.txt"]