FROM jubicoy/nginx-php:php7
ENV PIWIK_VERSION latest

RUN apt-get update && apt-get install -y \
    php7.0 php7.0-curl php7.0-gd php7.0-cli php7.0-mysql php-xml php7.0-mbstring \
    gzip \
    libgcrypt11-dev zlib1g-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libgeoip-dev \
    libpng12-dev \
    zip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -k https://builds.piwik.org/piwik-3.2.1-b1.tar.gz | tar zx -C /workdir/

# Add configuration files
ADD config/default.conf /etc/nginx/conf.d/default.conf
ADD config/php.ini /etc/php7/php.ini
ADD entrypoint.sh /workdir/entrypoint.sh

RUN chown -R 104:0 /var/www && chmod -R 777 /var/www && \
    chmod a+x /workdir/entrypoint.sh && chmod g+rw /workdir && \
    chmod -R 777 /workdir/piwik

EXPOSE 5000
USER 104
