FROM gitlab/dind

MAINTAINER mcasimir

#
# Node JS
#
RUN apt-get update
RUN apt-get install -y build-essential chrpath libssl-dev libxft-dev git
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
RUN apt-get install -y nodejs
ENV NPM_CONFIG_LOGLEVEL error

#
# Phantom Js
#
RUN apt-get install -y libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2
RUN tar xvjf phantomjs-1.9.8-linux-x86_64.tar.bz2

RUN mv phantomjs-1.9.8-linux-x86_64 /usr/local/share
RUN ln -sf /usr/local/share/phantomjs-1.9.8-linux-x86_64/bin/phantomjs /usr/local/bin

#
# Gulp
#
RUN npm i -g gulp
RUN npm i -g grunt
RUN npm i -g bower

RUN mkdir -p /usr/src/app

VOLUME /usr/src/app
WORKDIR /usr/src/app

CMD ["gulp"]
