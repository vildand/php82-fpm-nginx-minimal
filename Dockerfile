FROM php:7.4-fpm-alpine

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN apk update \
    && apk add --no-cache --virtual .build-deps \
        g++ make autoconf \
    && apk add --no-cache dos2unix git zip postgresql-dev libxslt-dev\
    && docker-php-ext-install pdo_pgsql pgsql xsl soap\
    && docker-php-ext-enable opcache\
    && apk del --purge .build-deps

WORKDIR /var/www