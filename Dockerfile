FROM arm32v7/debian:stable

RUN "echo" "deb http://http.us.debian.org/debian stretch non-free" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
	autoconf \
	automake \
	bison \
	bzip2 \
	flex \
	g++ \
	gawk \
	gcc \
	git \
	gperf \
	libexpat-dev \
	libtool \
	libtool-bin \
	make \
	ncurses-dev \
	nano \
	python \
	python-dev \
	python-serial \
	sed \
	texinfo \
	unrar \
	unzip \
	wget \
	patch \
	help2man\
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash espbuilder && usermod -a -G dialout espbuilder

USER espbuilder
ENV PATH /home/espbuilder/esp-open-sdk/xtensa-lx106-elf/bin:/home/espbuilder/esp-open-sdk/esptool/:$PATH
ENV XTENSA_TOOLS_ROOT /home/espbuilder/esp-open-sdk/xtensa-lx106-elf/bin
ENV SDK_BASE /home/espbuilder/esp-open-sdk/ESP8266_NONOS_SDK-2.1.0-18-g61248df

WORKDIR /home/espbuilder
RUN (cd /home/espbuilder && mkdir project) && \
  git config --global http.sslverify false && \
  git clone --recursive https://github.com/homebots/esp-open-sdk.git

RUN cd esp-open-sdk && make STANDALONE=n

COPY Makefile /home/espbuilder/
