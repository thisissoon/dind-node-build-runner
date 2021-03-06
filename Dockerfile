FROM gitlab/dind

MAINTAINER soon

ARG CHROME_DRIVER_VERSION=2.33
ARG NODE_VERSION=7.x

ENV DBUS_SESSION_BUS_ADDRESS=/dev/null \
  DEBIAN_FRONTEND=noninteractive \
  DEBCONF_NONINTERACTIVE_SEEN=true \
  SCREEN_WIDTH=1360 \
  SCREEN_HEIGHT=1020 \
  SCREEN_DEPTH=24 \
  DISPLAY=:99.0 \
  NPM_CONFIG_LOGLEVEL=error

COPY config.json /tmp/selenium-config.json
COPY chrome_launcher.sh /tmp/chrome_launcher.sh

RUN \
  apt-get update -qqy \
  && apt-get install -y software-properties-common python-software-properties \
  && add-apt-repository ppa:webupd8team/java -y \
  && curl -sL https://deb.nodesource.com/setup_$NODE_VERSION | sudo -E bash - \
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qqy \
  && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
  && apt-get install -y \
    build-essential \
    chrpath \
    libssl-dev \
    libxft-dev \
    nodejs \
    yarn \
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
  && npm i -g selenium-standalone@latest protractor@latest\
  && selenium-standalone install \
  && rm /tmp/chromedriver_linux64.zip \
    /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

WORKDIR /usr/src/app

CMD ["sh"]
