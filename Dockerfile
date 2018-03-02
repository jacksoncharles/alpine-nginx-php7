FROM php:fpm-alpine
MAINTAINER Charles Jackson <charles@jacksoncharles.co.uk>

RUN apk upgrade --update && apk add --no-cache \
  coreutils \
  freetype-dev \
  libjpeg-turbo-dev \
  libltdl \
  libmcrypt-dev \
  libpng-dev \
  $PHPIZE_DEPS \
  openssl-dev  

RUN pecl install mcrypt-1.0.1 \
docker-php-ext-enable mcrypt \
docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
docker-php-ext-install -j$(nproc) gd \
docker-php-ext-install mysqli \
docker-php-ext-install pdo_mysql \
docker-php-ext-install zip

RUN apk update
RUN apk add --update bash && rm -rf /var/cache/apk/*

RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

RUN apk --update add nginx \
					 supervisor --repository http://nl.alpinelinux.org/alpine/edge/community/

RUN mkdir -p /run/nginx

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
COPY config/php.ini /etc/php7/conf.d/zzz_custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf


EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]