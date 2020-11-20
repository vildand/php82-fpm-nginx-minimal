FROM php:7.4-fpm-alpine

WORKDIR /var/www

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN apk update \
    && apk add --no-cache --virtual .build-deps \
    g++ make autoconf \
    && apk add --no-cache dos2unix git zip postgresql-dev libxslt-dev\
    && docker-php-ext-install pdo_pgsql pgsql xsl soap\
    && docker-php-ext-enable opcache\
    && apk del --purge .build-deps \
    && adduser -D -u 1000 non-privileged \
    && chown -R 1000:1000 /var/www

RUN apk add --no-cache fcgi
RUN wget -O /usr/local/bin/php-fpm-healthcheck \
    https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck \
    && chmod +x /usr/local/bin/php-fpm-healthcheck

COPY status.conf /usr/local/etc/php-fpm.d/status.conf

USER 1000