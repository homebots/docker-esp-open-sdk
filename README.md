# darlanalves/espbuild - esp8266 compiler on Docker

Docker image of [esp-open-sdk](https://github.com/pfalcon/esp-open-sdk).

Makes building am esp8266 project a breeze.

## Project structure

A blank project looks like this:

```
-- src/
   index.c
-- Makefile
```

### src/index.c

```c
#ifndef _ESP_OPEN_SDK_
#define _ESP_OPEN_SDK_

#ifdef __cplusplus
extern "C" {
#endif

#include "osapi.h"

#include "os_type.h"
#include "osapi.h"
#include "user_interface.h"

#define loopTaskPriority        0
#define loopTaskQueueLength     1
#define printf(...) os_printf(__VA_ARGS__)

os_event_t user_procTaskQueue[loopTaskQueueLength];

void tick() {
  system_os_post(loopTaskPriority, 0, 0);
}

static void ICACHE_FLASH_ATTR
user_loop(os_event_t *events) {
  // do something here
  tick();
}

void ICACHE_FLASH_ATTR
user_init() {
  uart_div_modify(0, UART_CLK_FREQ / SERIAL_SPEED);

  // initialise here

  system_os_task(user_loop, loopTaskPriority, user_procTaskQueue, loopTaskQueueLength);
  tick();
}

#ifdef __cplusplus
}
#endif
```

### Makefile

```makefile
build:
	docker run --rm -it -v$$(pwd)/:/home/espbuilder/project darlanalves/espbuild:latest

flash:
	esptool.py --baud $(FLASH_SPEED) --port $(ESP_PORT) write_flash -fm qio -fs 512KB 0x00000 firmware/0x00000.bin 0x10000 firmware/0x10000.bin 0x7c000 firmware/0x7c000.bin

```

### Build and flash

You will need `esptool.py` to flash your binaries.
It can be installed with `pip` or directly from GitHub:

```bash
pip2 install esptool

# if that does not work:

git clone https://github.com/espressif/esptool.git ~/esptool
cd ~/esptool
python setup.py install
```

Then, from a terminal, just run the `make` commands from your project's folder:

```
$ make build

CC project/src/index.c
AR project/build/esp8266_app.a
LD project/build/esp8266.out
FW project/firmware/
esptool.py v1.2

$ make flash

```

