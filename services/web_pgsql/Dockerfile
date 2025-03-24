FROM php:fpm

# Instalar dependencias y configurar usuario existente
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql \
    && usermod -u 33 www-data \
    && groupmod -g 33 www-data

COPY . /var/www/html
RUN chown -R www-data:www-data /var/www/html