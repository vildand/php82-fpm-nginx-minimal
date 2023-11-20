# Minimal php8.2/fpm/nginx setup

All configs can be modified by env variables. See https://github.com/jwilder/dockerize.  

See all configs available in:
* usr/local/etc/php-fpm.d/www.conf.tmpl
* usr/local/etc/php/php.ini.tmpl

## Static Files  
You can serve static content ( non php files ) by copying them to a folder outside of normal webroot scope ( for security reasons ) and mounting them in nginx.
To do this you need to define two envs : 
* STATIC_FILES (path to where they are in the project scope)
* STATIC_FILES_PATH ( path to folder outside project scope and folder to be mounted in nginx )  

See usr/local/entrypoint.sh.


## 3rd party addons  

This project includes two 3rd party utilities as binaries:  
* https://github.com/jwilder/dockerize (used for config templating)
* https://github.com/renatomefi/php-fpm-healthcheck (used for kubernetes healthcheck and readiness probe)
  
They can be found in usr/local/bin and is maintained directly in the repo for build consistency.
