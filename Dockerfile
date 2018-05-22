FROM php:7.1-alpine
MAINTAINER Bart Reunes <metalarend@gmail.com>

# Install Composer globally - https://github.com/composer/composer

ENV COMPOSER_HOME /composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_BIN_DIR $COMPOSER_HOME/vendor/bin
ENV PATH $COMPOSER_BIN_DIR:$PATH

RUN curl https://getcomposer.org/installer -o /tmp/composer-setup.php \
    && curl https://composer.github.io/installer.sig -o /tmp/composer-setup.sig \
    && php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') !== trim(file_get_contents('/tmp/composer-setup.sig'))) { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('/tmp/composer-setup.php');" \
    && php -r "unlink('/tmp/composer-setup.sig');"

# Install Tini - https://github.com/krallin/tini

RUN apk add --no-cache tini

# Install PhpCodeFixer - https://github.com/wapmorgan/PhpCodeFixer
# - dependency: tput

RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini
RUN apk add --no-cache ncurses \
    && composer global require --dev wapmorgan/php-code-fixer \
    && chmod +x $COMPOSER_BIN_DIR/phpcf

# Package container

VOLUME ["/app"]
WORKDIR "/app"
ENTRYPOINT ["/sbin/tini", "--", "phpcf"]
