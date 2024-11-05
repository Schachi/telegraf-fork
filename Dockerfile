FROM golang:1.23.2-alpine3.20

WORKDIR /usr/src/app

# fpm ist ein in Ruby geschriebenes Tool um verschiedenste
# Packages (z.B. rpm) zu bauen. Als Voraussetzung muss
# rpm und ruby installiert sein.
# Siehe:
# https://fpm.readthedocs.io/en/v1.15.1/

# gcc, musl-dev und golangci-lint sind notwendig, um die von
# Telegraf vorgesehenen Tests vor Erstellung eines Pull Requests
# durchzufuehren.
# Siehe:
#  https://github.com/influxdata/telegraf/blob/release-1.32/CONTRIBUTING.md

RUN apk update && \
    apk add nano && \
    apk add git && \
    apk add make && \
    apk add gcc && \
    apk add musl-dev && \
    apk add golangci-lint && \
    apk add rpm && \
    apk add ruby && \
    gem install fpm
