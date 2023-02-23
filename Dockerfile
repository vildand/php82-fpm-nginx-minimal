FROM php:7.4-fpm-alpine

# SANE DEFAULTS
ENV PHPFPM_CATCH_WORKERS_OUTPUT=yes
ENV PHPFPM_DECORATE_WORKERS_OUTPUT=no
ENV PHPFPM_CLEAR_ENV=no
ENV PHPINI_EXPOSE_PHP=no

COPY usr /usr

RUN apk --update add --no-cache git zip postgresql-dev libxslt-dev fcgi openssl tini bash \
    && docker-php-ext-install pdo_pgsql pgsql xsl soap sockets \
    && docker-php-ext-enable opcache \
    && chown -R nobody:nobody /usr/local

USER nobody

ENTRYPOINT [ "/sbin/tini", "--", "/usr/local/entrypoint.sh" ]
CMD [ "php-fpm" ]