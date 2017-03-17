FROM blacklabelops/centos:7.3.1611

RUN \
yum install -y -q xorg-x11-server-Xvfb libXt gtk3 bash curl bzip2 psmisc dbus-x11 libpaper

RUN \
cd /opt && \
curl https://ftp.mozilla.org/pub/firefox/releases/52.0/linux-x86_64/en-US/firefox-52.0.tar.bz2 > firefox-52.0.tar.bz2 && \
ls -lah && \
tar -xjf firefox-52.0.tar.bz2 && \
rm firefox-52.0.tar.bz2

RUN \
# Create firefox + xvfb runner
echo $'#!/usr/bin/env sh\n\
Xvfb :0 -screen 0 1920x1080x24 -ac +extension GLX +render -noreset & \n\
DISPLAY=:0.0 /opt/firefox/firefox $@ \n\
killall Xvfb' > /usr/bin/firefox && \
chmod +x /usr/bin/firefox

# Install slimerjs
COPY . /usr/local/slimerjs
WORKDIR /usr/local/slimerjs

CMD "test/run_tests"
