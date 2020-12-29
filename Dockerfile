FROM darlanalves/debian-dev

WORKDIR /home/espbuilder
RUN chown debian:root /home/espbuilder && mkdir project
USER debian

# toolchain
RUN git clone --recursive https://github.com/homebots/esp-open-sdk.git -b v2.1.1
WORKDIR /home/espbuilder/esp-open-sdk

RUN make crosstool-NG
RUN make toolchain
RUN make libhal
RUN make libcirom

WORKDIR /home/espbuilder
RUN mv esp-open-sdk/xtensa-lx106-elf xtensa-lx106-elf && rm -rf esp-open-sdk

ENV PATH /home/espbuilder/xtensa-lx106-elf/bin:/home/espbuilder/esp-open-sdk/esptool/:$PATH

# esptool.py
RUN git clone -b master https://github.com/homebots/esptool.git

# SDK 2.1.1
RUN git clone https://github.com/homebots/ESP8266_NONOS_SDK.git -b 2.1.1 sdk && cd sdk && \
  (cd lib && mkdir -p tmp && cd tmp && xtensa-lx106-elf-ar x ../libcrypto.a && cd .. && xtensa-lx106-elf-ar rs libwpa.a tmp/*.o) && \
  cp lib/libgcc.a ../xtensa-lx106-elf/lib/gcc/xtensa-lx106-elf/4.8.5
# xtensa-lx106-elf-ar r lib/libmain.a user_rf_cal_sector_set.o && \

# @cp -Rf sdk/include/* xtensa-lx106-elf/sysroot/usr/include/
# @cp -Rf sdk/lib/* xtensa-lx106-elf/sysroot/usr/lib/
# @sed -e 's/\r//' sdk/ld/eagle.app.v6.ld | sed -e s@../ld/@@ > xtensa-lx106-elf/sysroot/usr/lib/eagle.app.v6.ld
# @sed -e 's/\r//' sdk/ld/eagle.rom.addr.v6.ld >$(TOOLCHAIN)/xtensa-lx106-elf/sysroot/usr/lib/eagle.rom.addr.v6.ld
# xtensa-lx106-elf-gcc -O2 -Isdk/include -c sdk/empty_user_rf_pre_init.c
# xtensa-lx106-elf-gcc -O2 -Isdk/include -c sdk/user_rf_cal_sector_set.c

ENV SDK_BASE /home/espbuilder/sdk
COPY Makefile /home/espbuilder/
