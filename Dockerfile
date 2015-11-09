FROM coderstephen/php7
MAINTAINER nmcaullay <nmcaullay@gmail.com>

# Silence debconf's endless prattle
ENV DEBIAN_FRONTEND noninteractive

CMD /bin/bash
