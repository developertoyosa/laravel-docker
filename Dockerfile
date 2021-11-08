#imagen base
FROM php:7.3-buster

#carpeta predeterminada
#WORKDIR /project

#RUN useradd -d /project userapp -s /bin/bash

#Desactivar modo interactivo
#ARG DEBIAN_FRONTEND=noninteractive

#Actualizar repositorio, instalar apt-utils, zip
RUN apt-get update \
    && apt-get install -y \
    zip \
    nano \
    zlib1g-dev \
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxml++2.6-dev \
    git

#Configura zip
#RUN docker-php-ext-configure zip --with-zlib-dir

#Instala extensión zip mbstring, pdo, pdo_mysql y configura mbstring, gd
RUN docker-php-ext-install zip mbstring pdo pdo_mysql bcmath gd
# && docker-php-ext-configure mbstring

#Instala y Configura GD
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

#Instalar composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

#Aumenta memoria PHP
RUN echo 'memory_limit = 2G' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini;

#Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh && bash nodesource_setup.sh && apt-get -y install nodejs

#Inicia con usuario userapp
#USER userapp

#inicio de la shell
CMD ["/bin/bash"]

