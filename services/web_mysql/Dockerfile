FROM php:apache

# Instalar la extensión MySQLi
RUN docker-php-ext-install mysqli

# Copiar el código de la web
COPY public/ /var/www/html/

# Dar permisos correctos
RUN chown -R www-data:www-data /var/www/html
