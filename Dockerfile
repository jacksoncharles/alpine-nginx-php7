FROM php:fpm-alpine
MAINTAINER Charles Jackson <charles.jackson@tjmorris.co.uk>

RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql

RUN apk update
RUN apk add --update bash && rm -rf /var/cache/apk/*

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