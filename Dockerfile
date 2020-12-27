FROM darlanalves/debian-dev

RUN useradd -ms /bin/bash espbuilder && usermod -a -G dialout espbuilder
USER espbuilder
WORKDIR /home/espbuilder

RUN (cd /home/espbuilder && mkdir project) && git clone --recursive -b homebots https://github.com/homebots/esp-open-sdk.git
RUN cd esp-open-sdk && make STANDALONE=n
RUN cp esp-open-sdk/sdk/lib/libgcc.a esp-open-sdk/xtensa-lx106-elf/lib/gcc/xtensa-lx106-elf/4.8.5/
ADD extras/*.h /home/espbuilder/esp-open-sdk/sdk/include/

ENV SDK_BASE /home/espbuilder/esp-open-sdk/sdk
ENV XTENSA_TOOLS_ROOT /home/espbuilder/esp-open-sdk/xtensa-lx106-elf/bin
ENV PATH /home/espbuilder/esp-open-sdk/xtensa-lx106-elf/bin:/home/espbuilder/esp-open-sdk/esptool/:$PATH

COPY Makefile /home/espbuilder/
