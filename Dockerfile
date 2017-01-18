FROM gitlab/dind

MAINTAINER soon

ENV CHROME_DRIVER_VERSION 2.27
ENV NODE_JS_VERSION 7

ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV SCREEN_WIDTH 1360
ENV SCREEN_HEIGHT 1020
ENV SCREEN_DEPTH 24
ENV DISPLAY :99.0
ENV NPM_CONFIG_LOGLEVEL error

COPY config.json /tmp/selenium-config.json
COPY chrome_launcher.sh /tmp/chrome_launcher.sh

RUN \
  apt-get update -qqy \
  && apt-get install -y software-properties-common python-software-properties \
  && add-apt-repository ppa:webupd8team/java -y \
  && curl -sL https://deb.nodesource.com/setup_$NODE_JS_VERSION.x | sudo -E bash - \
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
  && apt-get install -y \
    build-essential \
    chrpath \
    libssl-dev \
    libxft-dev \
    nodejs \
    oracle-java8-installer \
    unzip \
    xvfb \
    google-chrome-stable \
  && mv /tmp/chrome_launcher.sh /opt/google/chrome/google-chrome \
  && chmod +x /opt/google/chrome/google-chrome \
  && wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip \
  && unzip /tmp/chromedriver_linux64.zip -d /opt/selenium \
  && mv /opt/selenium/chromedriver /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION \
  && chmod 755 /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION \
  && ln -fs /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION /usr/bin/chromedriver \
  && mv /tmp/selenium-config.json /opt/selenium/config.json \
  && mkdir -p /usr/src/app \
  && npm i -g selenium-standalone@latest protractor@latest yarn@latest\
  && selenium-standalone install \
  && rm /tmp/chromedriver_linux64.zip \
    /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

WORKDIR /usr/src/app

CMD ["sh"]
