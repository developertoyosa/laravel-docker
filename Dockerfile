#imagen base
FROM php:7.2

#carpeta predeterminada
#WORKDIR /project

RUN useradd -d /project userapp -s /bin/bash

#Desactivar modo interactivo
#ARG DEBIAN_FRONTEND=noninteractive

#Actualizar repositorio, instalar apt-utils, zip
RUN apt-get update \
    && apt-get install -y \
    zip \
    zlib1g-dev \
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev

#Configura zip
#RUN docker-php-ext-configure zip --with-zlib-dir

#Instala extensión zip mbstring, pdo, pdo_mysql y configura mbstring, gd
RUN docker-php-ext-install zip mbstring pdo pdo_mysql bcmath
# && docker-php-ext-configure mbstring

#Instala y Configura GD
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

#Instalar composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

#Instalar git
RUN apt-get install -y git

#Inicia con usuario userapp
#USER userapp

#inicio de la shell
CMD ["/bin/bash"]

