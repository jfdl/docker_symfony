FROM php:8.1-apache

ARG SERVER_NAME

RUN apt-get update \
    && apt-get install -y --no-install-recommends locales apt-utils git libicu-dev g++ libpng-dev libjpeg-dev libxml2-dev libzip-dev libonig-dev libxslt-dev unzip libmagickwand-dev libmcrypt-dev librabbitmq-dev;

RUN a2enmod rewrite && a2enmod headers && a2enmod env && a2enmod http2

ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
ADD php.ini /usr/local/etc/php/conf.d/myphp.ini
RUN sed -i "s/#ServerName/ServerName ${SERVER_NAME}/g" /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen

RUN apt-get purge nodejs
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash
RUN apt-get install nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn

RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls && \
   mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer

RUN docker-php-ext-configure intl
RUN docker-php-ext-install pdo pdo_mysql gd opcache intl zip calendar dom mbstring xsl exif
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd
RUN pecl install imagick && docker-php-ext-enable imagick
RUN pecl install apcu && docker-php-ext-enable apcu
RUN pecl install amqp && docker-php-ext-enable amqp

RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN mv /root/.symfony5/bin/symfony /usr/local/bin/symfony && chmod +x /usr/local/bin/symfony

RUN usermod --uid 1000 www-data

WORKDIR /var/www

CMD ["apache2-foreground"]



