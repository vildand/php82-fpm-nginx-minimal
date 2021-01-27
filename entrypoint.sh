#!/usr/bin/env bash

set -x

# Static files handling
if [[ -z "${STATIC_FILES_PATH}" ]]; then
  echo "env STATIC_FILES_PATH not set, skipping static files copy!"
elif [[ -d "${STATIC_FILES_PATH}" ]]; then
  if [[ -n "${STATIC_FILES}" ]]; then
    echo "env STATIC_FILES_PATH and STATIC_FILES set, copying static files..."
    for STATIC_FILE in ${STATIC_FILES}; do
      cp -r "${STATIC_FILE}" "${STATIC_FILES_PATH}/"
    done
  else
    echo "env STATIC_FILES not set, nothing to copy."
  fi
else
  echo "STATIC_FILES_PATH ${STATIC_FILES_PATH} does not exist. Remember to mount a volume on the path."
fi

# Template www.conf for php-fpm
dockerize -template /usr/local/etc/php-fpm.d/www.conf.tmpl:/usr/local/etc/php-fpm.d/www.conf

# Template php.ini for php
dockerize -template /usr/local/etc/php/php.ini.tmpl:/usr/local/etc/php/php.ini

exec "/usr/local/bin/docker-php-entrypoint" "$@"