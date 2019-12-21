FROM alpine:3.10

RUN apk add --update runit nodejs npm haproxy && \
    rm -rf /var/cache/apk/*

ADD frontend /opt/app/frontend
RUN cd /opt/app/frontend && npm install && npm run build
ADD etc/service  /etc/service
ADD etc/haproxy  /etc/haproxy


EXPOSE 3030
ENTRYPOINT ["/sbin/runsvdir", "/etc/service"]
