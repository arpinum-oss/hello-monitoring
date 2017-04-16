FROM alpine:3.3

RUN apk add --update bash curl && \
    rm -rf /var/cache/apk/*

COPY src/*.sh /src/

WORKDIR /src

CMD ["./run.sh"]
