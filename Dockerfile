# Docker Image for PHP Tools

FROM php:8.1-cli-alpine

# Use PHP INI production file by default
# You can use a dev or custom version on child images
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

# Install Xdebug
RUN apk add --no-cache $PHPIZE_DEPS \
    && pecl install xdebug-3.1.5 \
    && docker-php-ext-enable xdebug \
    && apk del $PHPIZE_DEPS \
    && rm -rf /var/cache/apk/* \
    && touch /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

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
