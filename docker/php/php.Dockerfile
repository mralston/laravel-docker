FROM php:8.0-fpm

# Script to make installing extensions easier
# https://github.com/mlocati/docker-php-extension-installer/blob/master/README.md
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions

# Install extensions
RUN install-php-extensions pdo_mysql \
    && install-php-extensions redis \
    && install-php-extensions pcntl

# Prepare apt-get
RUN apt-get update

# NPM
RUN apt-get install -y nodejs npm
RUN npm install npm@latest -g


# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

# Git is useful
RUN apt-get install -y git

RUN git config --global credential.helper store

# Copy config files
COPY docker/php/conf.d/* /usr/local/etc/php/conf.d/
COPY docker/php/mime.types /etc/

# Install dig. Used to determine IP address of other containers
RUN apt-get install -y dnsutils

# Install dos2unix.
# Used to ensure start-container script remains viable Linux script in mixed Mac/Windows dev environment
RUN apt-get -y install dos2unix

# Copy start-container script
COPY docker/php/start-container.sh /bin/start-container
RUN dos2unix /bin/start-container
RUN chmod +x /bin/start-container

# Switch to website directory
WORKDIR /site

# Start container's process (CONTAINER_ROLE env variable determines what it does)
CMD start-container
