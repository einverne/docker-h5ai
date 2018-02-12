FROM ubuntu:16.04
MAINTAINER Christian Lück <christian@lueck.tv>

ENV DEBIAN_FRONTEND=noninteractive
ENV H5AI_VERSION 0.29.0

RUN apt-get update && apt-get install -y \
  nginx php7.0-fpm supervisor \
  wget unzip patch ffmpeg imagemagick 

RUN service php7.0-fpm start

# install h5ai and patch configuration
# RUN wget http:`(wget https://larsjung.de/h5ai/ -q -O -) | sed 's/.*href="\(.*\.zip\)".*/\1/p' | head -n1`
RUN wget http://release.larsjung.de/h5ai/h5ai-$H5AI_VERSION.zip
RUN unzip h5ai-$H5AI_VERSION.zip -d /usr/share/h5ai

# patch h5ai because we want to deploy it ouside of the document root and use /var/www as root for browsing
ADD h5ai-path.patch patch
RUN patch -p1 -u -d /usr/share/h5ai/_h5ai/private/php/core/ -i /patch && rm patch

ADD options.json.patch options.json.patch
RUN patch -p1 -u -d /usr/share/h5ai/_h5ai/private/conf/ -i /options.json.patch && rm options.json.patch

# 是否添加密码
ADD index.php.patch index.php.patch
RUN patch -p1 -u -d /usr/share/h5ai/_h5ai/public/ -i /index.php.patch && rm index.php.patch

# add h5ai as the only nginx site
ADD h5ai.nginx.conf /etc/nginx/sites-available/default

#WORKDIR /var/www

# add dummy files in case the container is not run with a volume mounted to /var/www
#RUN echo "Looks like you did not mount a volume to `/var/www`. See README.md for details." > /var/www/INSTALL.md
#RUN mkdir -p /var/www/first/second/third/fourth/fifth
#ADD README.md /var/www/README.md

# use supervisor to monitor all services
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf

# expose only nginx HTTP port
EXPOSE 80

# expose path
VOLUME /var/www

