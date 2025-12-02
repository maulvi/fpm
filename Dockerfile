FROM serversideup/php:8.5-fpm
USER root

# Combine semua RUN commands jadi satu layer
RUN install-php-extensions \
    mysqli pdo_mysql gd imagick \
    redis opcache bcmath zip \
    mbstring intl soap curl \
    dom xml exif fileinfo \
    apcu igbinary

# Cleanup di command yang sama
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER www-data
