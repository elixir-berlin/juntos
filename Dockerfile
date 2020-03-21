ARG ALPINE_VERSION=3.10

# Build image
FROM elixir:1.10.2-alpine AS build

RUN apk add --update git build-base

RUN mix local.hex --force && \
    mix local.rebar --force

ENV MIX_ENV=prod

RUN mkdir /build-src
WORKDIR /build-src

COPY ./api /build-src/

RUN mix do deps.get, deps.compile, compile

RUN mix release

# Final image
FROM alpine:3.10

RUN apk add --update runit nodejs npm haproxy ncurses-libs && \
    rm -rf /var/cache/apk/*

ADD frontend /opt/app/frontend
RUN cd /opt/app/frontend && npm install && npm run build
ADD etc/service  /etc/service
ADD etc/haproxy  /etc/haproxy

COPY --from=build /build-src/_build/prod/rel/api /opt/app/api

EXPOSE 3030
ENTRYPOINT ["/sbin/runsvdir", "/etc/service"]
