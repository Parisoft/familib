#include "def.h"

#ifndef __FAMIJOY__
#define __FAMIJOY__
typedef struct {
    u8_t curr[4];  // current state
    u8_t prev[4];  // previous state
} joy_t;
#endif

#define BUTTON_A (1 << 7)
#define BUTTON_B (1 << 6)
#define BUTTON_SELECT (1 << 5)
#define BUTTON_START (1 << 4)
#define PAD_UP (1 << 3)
#define PAD_DOWN (1 << 2)
#define PAD_LEFT (1 << 1)
#define PAD_RIGHT (1 << 0)

#define JOYPAD1 *((u8_t *)0x4016)
#define JOYPAD2 *((u8_t *)0x4017)

extern joy_t joy;
#pragma zpsym("joy1")

void __fastcall__ joy_poll(u8_t);

void __fastcall__ joy_poll_safe(u8_t);

#define joy_pressing(idx, btn) (joy.curr[idx] & (btn))

#define joy_pressed(idx, btn) (joy.prev[idx] & (btn))
