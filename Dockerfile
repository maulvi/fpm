# Base image - FPM untuk production
FROM serversideup/php:8.5-fpm

# Metadata
LABEL maintainer="your-email@example.com"
LABEL description="Production-ready PHP-FPM with common extensions"
LABEL version="1.0.0"

# Switch ke root untuk install extensions
USER root

# Install PHP extensions (merged WordPress + Laravel + Performance)
RUN install-php-extensions \
    # Database
    mysqli \
    pdo_mysql \
    # Images & Media
    gd \
    imagick \
    exif \
    # Text & Encoding
    mbstring \
    intl \
    iconv \
    # Compression & Archives
    zip \
    bz2 \
    # XML Processing
    dom \
    xml \
    simplexml \
    xmlreader \
    xmlwriter \
    soap \
    # Performance & Caching
    opcache \
    apcu \
    redis \
    igbinary \
    # Laravel Specific
    bcmath \
    # General
    curl \
    fileinfo

# Install Composer (latest version)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Cleanup untuk reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Switch kembali ke unprivileged user
USER www-data

# Working directory
WORKDIR /var/www/html

# Health check
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
    CMD php-fpm-healthcheck || exit 1

# Expose FPM port
EXPOSE 9000
