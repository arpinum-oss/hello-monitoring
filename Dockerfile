FROM alpine:3.3

RUN apk add --update bash curl && \
    rm -rf /var/cache/apk/*

COPY src /src

WORKDIR /src

CMD ["./register.sh"]
