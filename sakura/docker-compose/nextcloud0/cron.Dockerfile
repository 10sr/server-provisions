FROM nextcloud:14-fpm

# Requred for https source
RUN apt-get update && apt-get install -y apt-transport-https gnupg2

RUN curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo "deb https://deb.nodesource.com/node_6.x jessie main" >>/etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install -y nodejs wget
RUN npm install -g cron-cli

COPY crontab /

RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb -O /dumb-init.deb
RUN dpkg -i /dumb-init.deb

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/bin/cron", "/crontab"]
