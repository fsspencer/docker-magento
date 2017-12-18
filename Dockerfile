FROM php:5.6-apache
MAINTAINER fsspencer <francis.s.spencer@gmail.com>

ENV N98_MAGERUN_VERSION 1.96.1
ENV N98_MAGERUN_URL https://raw.githubusercontent.com/netz98/n98-magerun/$N98_MAGERUN_VERSION/n98-magerun.phar

RUN curl -o /usr/local/bin/n98-magerun $N98_MAGERUN_URL \
    && chmod +x /usr/local/bin/n98-magerun

RUN requirements="libpng12-dev libmcrypt-dev libmcrypt4 libcurl3-dev libfreetype6 libjpeg62-turbo libpng12-dev libfreetype6-dev libjpeg62-turbo-dev mysql-client" \
    && apt-get update && apt-get install -y $requirements && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install mbstring \
    && requirementsToRemove="libpng12-dev libmcrypt-dev libcurl3-dev libpng12-dev libfreetype6-dev libjpeg62-turbo-dev" \
    && apt-get purge --auto-remove -y $requirementsToRemove

RUN usermod -u 1000 www-data
RUN a2enmod rewrite

COPY .docker/bin/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*

RUN setup-cron

VOLUME /var/www/html
WORKDIR /var/www/html
