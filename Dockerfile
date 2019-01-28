FROM debian:8.8

RUN "echo" "deb http://http.us.debian.org/debian wheezy non-free" >> /etc/apt/sources.list

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
	help2man

RUN useradd -ms /bin/bash espbuilder && usermod -a -G dialout espbuilder

USER espbuilder
WORKDIR /home/espbuilder

RUN cd /home/espbuilder && mkdir project
RUN (git clone --recursive https://github.com/pfalcon/esp-open-sdk.git && cd esp-open-sdk && make STANDALONE=n)

ENV PATH /home/espbuilder/esp-open-sdk/xtensa-lx106-elf/bin:/home/espbuilder/esp-open-sdk/esptool/:$PATH
ENV XTENSA_TOOLS_ROOT /home/espbuilder/esp-open-sdk/xtensa-lx106-elf/bin
ENV SDK_BASE /home/espbuilder/esp-open-sdk/ESP8266_NONOS_SDK-2.1.0-18-g61248df
COPY Makefile /home/espbuilder/
ADD extras /home/espbuilder/extras

CMD make clean && make && cp esp-open-sdk/sdk/bin/esp_init_data_default.bin project/firmware/0x7c000.bin
