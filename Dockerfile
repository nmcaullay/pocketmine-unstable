FROM coderstephen/php7
MAINTAINER nmcaullay <nmcaullay@gmail.com>

# Silence debconf's endless prattle
ENV DEBIAN_FRONTEND noninteractive

#Create the pocketmine user
RUN useradd -u 1000 -g 100 pocketmine

#Create the home folder, set the permissions
RUN mkdir /pocketmine
RUN cd /pocketmine

RUN wget http://jenkins.pocketmine.net/job/PocketMine-MP-Bleeding/48/artifact/PocketMine-MP_1.6dev-48_mcpe-0.12_f9d7e204_API-1.13.0.phar -O /pocketmine/PocketMine-MP.phar

COPY resources/eula.txt /pocketmine/eula.txt

# Change user to pocketmine
RUN chown -R pocketmine:100 /pocketmine

#Expose the port from the container
EXPOSE 19132

CMD ["/usr/local/php70/bin/php", "/pocketmine/PocketMine-MP.phar"]

