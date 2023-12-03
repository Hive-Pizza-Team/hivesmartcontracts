FROM node:20-alpine

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/main' >> /etc/apk/repositories
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/community' >> /etc/apk/repositories

RUN apk update
RUN apk add mongodb-tools
RUN apk add bash

WORKDIR /hivesmartcontracts

COPY package-lock.json .
COPY package.json .

RUN npm ci

COPY . .

CMD ["/bin/bash", "./docker-start.sh"]


