FROM jubicoy/nginx-php:latest
ENV PIWIK_VERSION latest

RUN apt-get update && apt-get install -y \
    php5-mysql php5-gd \
    gzip \
    libgcrypt11-dev zlib1g-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libgeoip-dev \
    libpng12-dev \
    zip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -k https://builds.piwik.org/piwik-${PIWIK_VERSION}.tar.gz | tar zx -C /workdir/

# Add configuration files
ADD config/default.conf /etc/nginx/conf.d/default.conf
ADD config/php.ini /etc/php5/fpm/php.ini
ADD entrypoint.sh /workdir/entrypoint.sh

RUN chown -R 104:0 /var/www && chmod -R 777 /var/www && \
    chmod a+x /workdir/entrypoint.sh && chmod g+rw /workdir && \
    chmod -R 777 /workdir/piwik

EXPOSE 5000
USER 104

VOLUME ["/var/www/piwik"]
