FROM ubuntu:xenial
MAINTAINER Chris Hutchinson <chris@brushd.com>

ENV SLIMERJS_VERSION=master \
	SLIMERJSLAUNCHER=/usr/bin/firefox \
	FIREFOX_VERSION=56.0.2-0 \
	DISPLAY=:0.0

CMD ["sh", "/start.sh"]

# install xvfb
RUN apt-get update && apt-get install -y \
	ca-certificates \
	xvfb && \
	apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

# install slimerjs
RUN apt-get update && apt-get install -y --allow-unauthenticated unzip wget && \
	cd /tmp && \
	wget "https://github.com/laurentj/slimerjs/archive/${SLIMERJS_VERSION}.zip" -O slimerjs.zip && \
	unzip slimerjs.zip && \
	mv -f slimerjs-${SLIMERJS_VERSION}/src /usr/local/slimerjs && \
	ln -s /usr/local/slimerjs/slimerjs /usr/local/bin/slimerjs && \
	apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

# install firefox
RUN cd /tmp && \
	apt-get update && \
	apt-get install $(apt-cache depends firefox | grep Depends | sed "s/.*ends:\ //" | tr '\n' ' ') -y --allow-unauthenticated && \
	wget sourceforge.net/projects/ubuntuzilla/files/mozilla/apt/pool/main/f/firefox-mozilla-build/firefox-mozilla-build_${FIREFOX_VERSION}ubuntu1_amd64.deb && \
	dpkg -i firefox-mozilla-build_${FIREFOX_VERSION}ubuntu1_amd64.deb && \
	apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

COPY application.ini /usr/local/slimerjs/

# config files ordered by likelihood of being updated
COPY start.sh /

COPY scripts/ /scripts/
WORKDIR scripts/
