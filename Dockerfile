FROM php:8-fpm

# SANE DEFAULTS
ENV PHPINI_EXPOSE_PHP=Off
ENV PHPINI_VARIABLES_ORDER=EGPCS
ENV PHPFPM_PROCESS_CONTROL_TIMEOUT: 10s
ENV PHPFPM_ACCESS_LOG: /dev/null
ENV PHPFPM_PM: static

COPY usr /usr

RUN apt update  \
    && apt install -y libpq-dev libxslt-dev git zip openssl tini bash \
    && docker-php-ext-install pdo_pgsql pgsql xsl soap sockets \
    && docker-php-ext-enable opcache \
    && apt autoremove && apt clean
    #&& chown -R www-data:www-data /usr/local /var/www

#USER 0 # www-data

#ENTRYPOINT [ "tini", "--", "/usr/local/entrypoint.sh" ]
#CMD [ "php-fpm" ]