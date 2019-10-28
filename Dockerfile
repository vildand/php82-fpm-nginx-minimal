FROM php:7.3-fpm-alpine

RUN apk update \
    && apk add --no-cache --virtual .build-deps \
        g++ make autoconf \
    && apk add --no-cache git zip postgresql-dev dos2unix\
    && docker-php-ext-install pdo_pgsql pgsql \
    && docker-php-ext-enable opcache \
    && apk del --purge .build-deps

WORKDIR /var/www