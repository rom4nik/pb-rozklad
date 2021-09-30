FROM alpine:3.14


RUN apk add --no-cache bash tzdata curl imagemagick nodejs npm && \
    ln -snf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime && echo Europe/Warsaw > /etc/timezone

COPY src /app
WORKDIR /app/msg_facebook/
RUN npm install

USER 1000:1000
VOLUME ["/data"]

CMD ["/bin/sh", "/app/runner.sh"]