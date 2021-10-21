FROM alpine:3

COPY entrypoint.sh /opt/entrypoint.sh

RUN set -ex &&\
    echo "http://dl-3.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories &&\
    apk update && apk add --update stunnel &&\
    apk update && apk add --update openssl &&\
    apk update && apk add --update bash &&\
    chmod +x /opt/entrypoint.sh &&\
    rm -rf /tmp/* \
           /var/cache/apk/*


EXPOSE 443

RUN stunnel -version

ENTRYPOINT ["/opt/entrypoint.sh"] 
