#include "../def/def.h"

#define BUTTON_A (1 << 7)
#define BUTTON_B (1 << 6)
#define BUTTON_SELECT (1 << 5)
#define BUTTON_START (1 << 4)
#define PAD_UP (1 << 3)
#define PAD_DOWN (1 << 2)
#define PAD_LEFT (1 << 1)
#define PAD_RIGHT (1 << 0)

extern joy_t joy1;
#pragma zpsym("joy1")
extern joy_t joy2;
#pragma zpsym("joy2")

void joy1_poll(void);

void joy2_poll(void);

void joy1_poll_safe(void);

void joy2_poll_safe(void);

#define joy1_pressing(btn) (joy1.curr & btn)

#define joy1_pressed(btn) (joy1.prev & btn)

#define joy2_pressing(btn) (joy2.curr & btn)

#define joy2_pressed(btn) (joy2.prev & btn)