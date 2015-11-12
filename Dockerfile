# Use the latest Ubuntu base image
FROM ubuntu:latest
MAINTAINER nmcaullay <nmcaullay@gmail.com>

# Silence debconf's endless prattle
ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://repos.zend.com/zend-server/early-access/php7/repos ubuntu/" >> /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y --force-yes install php7-nightly
RUN cp /usr/local/php7/libphp7.so /usr/lib/apache2/modules/
RUN cp /usr/local/php7/php7.load /etc/apache2/mods-available/

RUN a2dismod mpm_event
RUN a2enmod mpm_prefork
RUN a2enmod php7

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

CMD ["/usr/local/php70/bin/php", "/pocketmine/PocketMine-MP.phar"]

