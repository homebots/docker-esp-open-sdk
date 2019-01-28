#include "osapi.h"

#ifndef SERIAL_SPEED
#define SERIAL_SPEED 115200
#endif

#define loopTaskPriority        0
#define loopTaskQueueLength     1

os_event_t user_procTaskQueue[loopTaskQueueLength];
static void user_loop(os_event_t *events);

static void ICACHE_FLASH_ATTR
user_loop(os_event_t *events) {
  loop();
  system_os_post(loopTaskPriority, 0, 0);
}

void ICACHE_FLASH_ATTR
user_init() {
  uart_div_modify(0, UART_CLK_FREQ / SERIAL_SPEED);
  setup();

  system_os_task(user_loop, loopTaskPriority,user_procTaskQueue, loopTaskQueueLength);
  system_os_post(loopTaskPriority, 0, 0 );
}
