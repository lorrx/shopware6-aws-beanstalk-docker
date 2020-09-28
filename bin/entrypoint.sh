#!/bin/bash

#sbin/init_shopware.sh
#sbin/set_env.sh
#sbin/set_s3_credentials.sh
service php${PHP_VERSION}-fpm start; nginx -g 'daemon off;'
