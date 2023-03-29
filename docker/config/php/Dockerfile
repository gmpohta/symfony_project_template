ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm-alpine

ARG TIMEZONE
ARG COMPOSER_VERSION

RUN addgroup -g 1000 app && adduser -u 1000 -G app -s /bin/sh -D app

RUN apk update \
    && apk add --no-cache pcre-dev postgresql-dev zlib-dev autoconf g++ make \
    libpng libpng-dev libpq-dev \
    && pecl update-channels \
    && pecl install redis apcu \
    && docker-php-ext-enable redis apcu \
    && docker-php-ext-install gd opcache pdo pgsql pdo_pgsql intl \
    && pecl clear-cache \
    && docker-php-source delete \
    && rm -frv /var/cache/apk/* \
    && curl -sS https://getcomposer.org/installer | php -- \
        --install-dir=/usr/bin \
        --filename=composer  \
        --version=${COMPOSER_VERSION} \
    && chmod +x /usr/bin/composer

RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini \
    # [php.ini] configuration
    && sed -i "s/;date.timezone =.*/date.timezone = ${TIMEZONE}/g" /usr/local/etc/php/php.ini \
    && sed -i 's/expose_php =.*/expose_php = Off/g' /usr/local/etc/php/php.ini \
    && sed -i 's/max_execution_time =.*/max_execution_time = 300/g' /usr/local/etc/php/php.ini \
    && sed -i 's/max_input_time =.*/max_input_time = 300/g' /usr/local/etc/php/php.ini \
    && sed -i 's/memory_limit =.*/memory_limit = 256M/g' /usr/local/etc/php/php.ini \
    && sed -i 's/post_max_size =.*/post_max_size = 24M/g' /usr/local/etc/php/php.ini \
    && sed -i 's/;realpath_cache_ttl =.*/realpath_cache_ttl = 600/g' /usr/local/etc/php/php.ini \
    && sed -i 's/upload_max_filesize =.*/upload_max_filesize = 24M/g' /usr/local/etc/php/php.ini \
    && sed -i 's/variables_order =.*/variables_order = "EGPCS"/g' /usr/local/etc/php/php.ini \
    # [OPCache] configuration
    && echo "opcache_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.memory_consumption=256" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.max_accelerated_files=20000" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    # [APCu] configuration
    && echo "apc.shm_size=256M" >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini \
    # [php-fpm.conf] configuration
    && sed -i 's/;emergency_restart_threshold =.*/emergency_restart_threshold = 20/g' /usr/local/etc/php-fpm.conf \
    && sed -i 's/;emergency_restart_interval =.*/emergency_restart_interval = 1m/g' /usr/local/etc/php-fpm.conf \
    && sed -i 's/;process_control_timeout =.*/process_control_timeout = 30s/g' /usr/local/etc/php-fpm.conf

USER app

WORKDIR /var/www/app
