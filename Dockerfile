FROM php:8.0-apache

RUN apt-get update \
    && apt-get install --yes --no-install-recommends libpq-dev \
       libzip-dev \
       libpng-dev \
       libjpeg-dev \
       zlib1g-dev \
       zip \
       git \
       wget \
       libargon2-dev \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install xdebug-3.0.3 \
    && docker-php-ext-install zip \
    && docker-php-ext-enable xdebug

COPY docker/vhosts/000-default.conf /etc/apache2/sites-available/000-default.conf
# Install Composer
COPY --from=composer:2.1.3 /usr/bin/composer /usr/local/bin/composer

# Enable apache rewrite
RUN a2enmod rewrite
RUN docker-php-ext-enable xdebug
RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/php.ini
RUN echo "max_execution_time=1800" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

EXPOSE 3001

COPY . /var/www/html/

WORKDIR /var/www/html