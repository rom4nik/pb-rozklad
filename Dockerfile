FROM alpine:3.17


RUN apk add --no-cache bash tzdata curl imagemagick \
    nodejs npm \
    jq file coreutils && \
    ln -snf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime && echo Europe/Warsaw > /etc/timezone

COPY src /app
WORKDIR /app/msg_facebook/
RUN npm install && apk del npm 

USER 1000:1000
VOLUME ["/data"]

CMD ["/bin/sh", "/app/runner.sh"]