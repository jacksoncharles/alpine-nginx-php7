FROM alpine:latest
MAINTAINER Kevin Holmes <kevin.holmes@tjmorris.co.uk>

RUN apk add --update bash && rm -rf /var/cache/apk/*

# Install packages
RUN apk --update add php7 \ 
                     php7-fpm \
		     php7-pdo \
		     php7-pdo_mysql \
		     php7-mcrypt \
		     php7-ctype \
		     php7-zlib \
		     php7-gd \
		     php7-intl \
		     php7-sqlite3 \
		     php7-pgsql \
		     php7-xml \
		     php7-xsl \
		     php7-curl \
		     php7-openssl \
		     php7-iconv \
		     php7-json \
		     php7-phar \
		     php7-soap \
		     php7-dom \
                     nginx \
                     supervisor --repository http://nl.alpinelinux.org/alpine/edge/testing/

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



