FROM php:7.3-fpm-alpine

RUN apk update \
    && apk add --no-cache --virtual .build-deps \
        g++ make autoconf \
    && apk add --no-cache git zip yaml-dev postgresql-dev \
    && docker-php-ext-install pdo_pgsql pgsql \
    && docker-php-ext-enable opcache \
    && pecl install yaml-2.0.4 \
    && docker-php-ext-enable yaml \
    && apk del --purge .build-deps

WORKDIR /var/www