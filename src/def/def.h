#ifndef __FAMITYPES__
#define __FAMITYPES__
typedef unsigned char      u8_t;
typedef signed char        s8_t;
typedef unsigned short int u16_t;
typedef signed short int   s16_t;
typedef unsigned char bool;

typedef struct {
    u8_t curr;  // current state
    u8_t prev;  // previous state
} joy_t;

typedef struct {
    u8_t x;
    u8_t y;
    u8_t spr;
    u8_t opt;
} sprite_t;

typedef struct {
    u8_t x;
    u8_t y;
} scroll_t;

typedef struct {
    u8_t     ctrl;
    u8_t     mask;
    scroll_t scroll;
    u8_t     system;
} ppu_t;
#endif
#define null 0
#define true 1
#define false 0