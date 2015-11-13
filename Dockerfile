# Use the latest Ubuntu base image
FROM ubuntu:latest
MAINTAINER nmcaullay <nmcaullay@gmail.com>

# Silence debconf's endless prattle
ENV DEBIAN_FRONTEND noninteractive

# install PHP, Apache and WGET
#RUN echo "deb http://repos.zend.com/zend-server/early-access/php7/repos ubuntu/" >> /etc/apt/sources.list
#RUN apt-get -y update
#RUN apt-get -y --force-yes install php7-nightly apache2 python3-yaml wget autoconf

# Install and set up packages we will need to compile PHP
RUN apt-get update
RUN apt-get install -y \
    apache2-mpm-prefork \
    apache2-prefork-dev \
    aufs-tools \
    automake \
    btrfs-tools \
    build-essential \
    curl \
    enchant \
    git \
    libbz2-dev \
    libcurl4-openssl-dev \
    libedit-dev \
    libenchant-dev \
    libfreetype6-dev \
    libgmp-dev \
    libicu-dev \
    libjpeg8-dev \
    libmcrypt-dev \
    libpng12-dev \
    libpspell-dev \
    libreadline-dev \
    libsnmp-dev \
    libssl-dev \
    libt1-dev \
    libtidy-dev \
    libvpx-dev \
    libxml2-dev \
    libxslt1-dev \
    mcrypt \
    re2c \
    wget \
    python3-yaml

RUN curl -O http://launchpadlibrarian.net/140087283/libbison-dev_2.7.1.dfsg-1_amd64.deb && \
    curl -O http://launchpadlibrarian.net/140087282/bison_2.7.1.dfsg-1_amd64.deb && \
    dpkg -i libbison-dev_2.7.1.dfsg-1_amd64.deb && \
    dpkg -i bison_2.7.1.dfsg-1_amd64.deb && \
    apt-mark hold libbison-dev && apt-mark hold bison

# Clone the PHP source repository
RUN git clone https://github.com/php/php-src.git /usr/local/src/php

# Compile PHP7 right now to bootstrap everything else
RUN cd /usr/local/src/php && ./buildconf && ./configure \
    --prefix=/usr/local/php7 \
    --with-config-file-path=/usr/local/php7 \
    --with-config-file-scan-dir=/usr/local/php7/conf.d \
    --with-apxs2=/usr/bin/apxs2 \
    --with-libdir=/lib/x86_64-linux-gnu \
    --enable-fpm \
    --enable-maintainer-zts \
    --enable-pthreads \
    --with-openssl && \
    make && make install

#RUN cp /usr/local/php7/libphp7.so /usr/lib/apache2/modules/
#RUN cp /usr/local/php7/php7.load /etc/apache2/mods-available/

RUN a2dismod mpm_event
RUN a2enmod mpm_prefork
RUN a2enmod php7

RUN cd /tmp
RUN wget http://pear.php.net/go-pear.phar -O /tmp/go-pear.phar
RUN /usr/local/php7/bin/php /tmp/go-pear.phar
RUN /usr/local/php7/bin/pear install pecl/pthreads

RUN service apache2 restart

# update apt-get, and install wget
#RUN apt-get -y update
#RUN apt-get -y install python3-yaml wget

#Create the pocketmine user
RUN useradd -u 1000 -g 100 pocketmine

#Create the home folder, set the permissions
RUN mkdir /pocketmine
RUN cd /pocketmine

#RUN wget http://jenkins.pocketmine.net/job/PocketMine-MP-Bleeding/48/artifact/PocketMine-MP_1.6dev-48_mcpe-0.12_f9d7e204_API-1.13.0.phar -O /pocketmine/PocketMine-MP.phar
RUN wget http://jenkins.pocketmine.net/job/PocketMine-MP-PR/402/artifact/PocketMine-MP_1.7dev_PR-3672_94982d01_API-1.13.0.phar -O /pocketmine/PocketMine-MP.phar

COPY resources/eula.txt /pocketmine/eula.txt

# Change user to pocketmine
RUN chown -R pocketmine:100 /pocketmine

#Expose the port from the container
EXPOSE 19132

CMD ["/usr/local/php7/bin/php", "/pocketmine/PocketMine-MP.phar"]

