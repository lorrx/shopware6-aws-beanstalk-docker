FROM ubuntu:20.04

ENV PHP_VERSION=7.4
ENV MODE="prod"
ENV S3_STORAGE=1
ARG SHOPWARE_INSTALL_FILE="install_v6.3.1.0_30a2e48bba09fcdca287d2062aa73b6d25de7be8"
ARG EXTENSION_DIR

# Install Nginx
RUN apt-get update
RUN apt-get install -y nginx software-properties-common

# Install PHP
RUN add-apt-repository ppa:ondrej/php
RUN apt-get install php${PHP_VERSION} php${PHP_VERSION}-cli php${PHP_VERSION}-fpm php${PHP_VERSION}-common \
php${PHP_VERSION}-mysql php${PHP_VERSION}-curl php${PHP_VERSION}-json php${PHP_VERSION}-zip php${PHP_VERSION}-gd \
php${PHP_VERSION}-xml php${PHP_VERSION}-mbstring php${PHP_VERSION}-intl php${PHP_VERSION}-opcache git unzip socat \
curl wget bash-completion -y
RUN wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
RUN tar xfz ioncube_loaders_lin_x86-64.tar.gz
COPY ./etc /etc
RUN EXTENSION_DIR=$(php -i | grep extension_dir | cut -d ">" -f 2 | cut -d "=" -f 1 | sed -e "s/ //g"); \
cp ioncube/ioncube_loader_lin_${PHP_VERSION}.so ${EXTENSION_DIR}; \
echo "zend_extension = ${EXTENSION_DIR}/ioncube_loader_lin_${PHP_VERSION}.so" >> /etc/php/${PHP_VERSION}/fpm/php.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Download Shopware
RUN mkdir -p /var/www/html/shopware
WORKDIR /var/www/html/shopware
RUN wget https://www.shopware.com/en/Download/redirect/version/sw6/file/${SHOPWARE_INSTALL_FILE}.zip
RUN unzip ${SHOPWARE_INSTALL_FILE}.zip && rm ${SHOPWARE_INSTALL_FILE}.zip
COPY config/ ./config
COPY env/ ./
RUN composer install
RUN chown -R www-data:www-data /var/www/html/shopware
RUN chmod -R 755 /var/www/html/shopware
RUN ln -s /etc/nginx/sites-available/shopware.conf /etc/nginx/sites-enabled/
RUN nginx -t

COPY bin/ sbin/

EXPOSE 5000
STOPSIGNAL SIGTERM
ENTRYPOINT "./sbin/entrypoint.sh"
