FROM php:7.4-fpm-alpine

# Install dependencies
RUN apk add --no-cache fcgi openssl tini bash

# Install php-fpm-healthcheck
RUN wget -O /usr/local/bin/php-fpm-healthcheck \
    https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck \
    && chmod +x /usr/local/bin/php-fpm-healthcheck

# Enable status endpoint in php-fpm
ADD status.conf /usr/local/etc/php-fpm.d/status.conf

# Install dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

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
    && chown -R 1000:1000 /usr/local/etc/php-fpm.d

ADD entrypoint.sh /entrypoint.sh
ADD www.conf.tmpl /usr/local/etc/php-fpm.d/www.conf.tmpl

USER 1000

ENTRYPOINT [ "/sbin/tini", "--", "/entrypoint.sh" ]
CMD [ "php-fpm" ]
