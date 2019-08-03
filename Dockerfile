FROM debian:stable

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
	&& apt-get install -y ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash espbuilder && usermod -a -G dialout espbuilder

USER espbuilder
WORKDIR /home/espbuilder
ENV PATH /home/espbuilder/esp-open-sdk/xtensa-lx106-elf/bin:/home/espbuilder/esp-open-sdk/esptool/:$PATH
ENV XTENSA_TOOLS_ROOT /home/espbuilder/esp-open-sdk/xtensa-lx106-elf/bin
ENV SDK_BASE /home/espbuilder/esp-open-sdk/ESP8266_NONOS_SDK-2.1.0-18-g61248df

RUN (cd /home/espbuilder && mkdir project) && git clone --recursive -b homebots https://github.com/homebots/esp-open-sdk.git
RUN cd esp-open-sdk && make STANDALONE=n
RUN cp esp-open-sdk/sdk/lib/libgcc.a esp-open-sdk/xtensa-lx106-elf/lib/gcc/xtensa-lx106-elf/4.8.5/
COPY Makefile /home/espbuilder/
RUN cd esp-open-sdk/sdk && git remote remove origin && git remote add origin https://github.com/homebots/ESP8266_NONOS_SDK && git fetch && git checkout -f release/v3.0.0
