FROM serversideup/php:8.5-fpm

LABEL maintainer="maulvibiz@gmail.com"
LABEL description="Production-ready PHP-FPM with common extensions"

USER root

RUN install-php-extensions \
    mysqli pdo_mysql gd imagick \
    redis opcache bcmath zip \
    mbstring intl soap curl \
    dom xml exif fileinfo \
    apcu igbinary bz2 iconv \
    simplexml xmlreader xmlwriter

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER www-data

# REMOVE atau COMMENT WORKDIR ini
WORKDIR /var/www/html

# Health check tetap bisa tanpa explicit WORKDIR
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
    CMD php-fpm-healthcheck || exit 1

EXPOSE 9000
