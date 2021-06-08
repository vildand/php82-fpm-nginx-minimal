FROM registry.t.cpm.dev/library/dockerize:master20201126113825 as addon_dockerize
FROM registry.t.cpm.dev/library/php-fpm-healthcheck:master20201126144236 as addon_healthcheck
FROM php:7.4-fpm-alpine

COPY --from=addon_dockerize /usr/local/bin/dockerize /usr/local/bin/dockerize
COPY --from=addon_healthcheck /usr/local/bin/php-fpm-healthcheck /usr/local/bin/php-fpm-healthcheck


RUN apk update \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && apk add --no-cache git zip postgresql-dev libxslt-dev fcgi openssl tini bash\
    && docker-php-ext-install pdo_pgsql pgsql xsl soap\
    && docker-php-ext-enable opcache\
    && apk del --purge .build-deps \
    && adduser -D -u 1000 non-privileged \
    && chown -R 1000:1000 /usr/local

COPY conf/www.conf.tmpl /usr/local/etc/php-fpm.d/www.conf.tmpl
COPY conf/php.ini.tmpl /usr/local/etc/php/php.ini.tmpl
COPY entrypoint.sh /entrypoint.sh
RUN apk update && apk add --no-cache dos2unix \
    && dos2unix /usr/local/etc/php-fpm.d/www.conf.tmpl /entrypoint.sh \
    && apk del --purge dos2unix

USER 1000

ENTRYPOINT [ "/sbin/tini", "--", "/entrypoint.sh" ]
CMD [ "php-fpm" ]