# Docker Image for PHP Tools

FROM php:8.2-cli-alpine

# Use PHP INI production file by default
# You can use a dev or custom version on child images
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

# Set basic OPCache config, can be overridden with environment
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="10000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="192" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10" \
    PHP_OPCACHE_ENABLE_CLI="0"

# Install Xdebug
RUN apk add --no-cache sqlite linux-headers libzip-dev $PHPIZE_DEPS autoconf \
    build-base openssl-dev pcre-dev libpq libpq-dev \
        rabbitmq-c rabbitmq-c-dev \
    && pecl install xdebug && docker-php-ext-enable xdebug \
    && pecl install redis && docker-php-ext-enable redis \
    && pecl install amqp && docker-php-ext-enable amqp \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo_pgsql pdo_mysql mysqli sockets \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install pcntl && docker-php-ext-enable pcntl \
    && docker-php-ext-install opcache \
    && docker-php-source delete \
    && apk del linux-headers $PHPIZE_DEPS autoconf build-base openssl-dev \
        pcre-dev libpq-dev rabbitmq-c-dev \
    && rm -rf /var/cache/apk/* \
    && touch /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

COPY etc/opcache.ini /usr/local/etc/php/conf.d/phptools-opcache.ini
COPY etc/php.owasp.ini /usr/local/etc/php/conf.d/phptools-owasp.ini

# Install Composer to shared location
RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/ \
  && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

# Add unprivileged user
RUN addgroup phpuser -g 1001 \
  && adduser -S -u 1001 -G phpuser -h /home/phpuser -s /bin/bash phpuser

# Create user directories and files
RUN mkdir -p \
  /home/phpuser/.composer/cache \
  /home/phpuser/.ssh \
  /home/phpuser/.local/share/psysh \
  /home/phpuser/app \
  && touch /home/phpuser/.ssh/known_hosts \
  && chown -R phpuser:phpuser /home/phpuser

# Use unprivileged user from now on
USER phpuser
ENV HOME /home/phpuser

WORKDIR $HOME

# Add composer to the path (for raw shell)
RUN echo "export PATH=~/.composer/vendor/bin:\$PATH" >> ~/.profile
ENV ENV="/home/phpuser/.profile"

# Install: psysh with PHP manual, code sniffer, psalm, phpunit
RUN composer g require psy/psysh:@stable \
  && curl -LSso ~/.local/share/psysh/php_manual.sqlite http://psysh.org/manual/en/php_manual.sqlite \
  && composer g require squizlabs/php_codesniffer:@stable \
  && composer g require vimeo/psalm:@stable \
  && composer g require phpunit/phpunit:@stable

# This working dir will be mapped to the current working directory
WORKDIR $HOME/app

ENTRYPOINT ["php"]
