#ifndef __FAMITYPES__
#define __FAMITYPES__
typedef unsigned char      u8;
typedef signed char        s8;
typedef unsigned short int u16;
typedef signed short int   s16;
typedef unsigned char bool;

typedef struct {
    u8 curr;  // current state
    u8 prev;  // previous state
} joy_t;

typedef struct {
    u8 x;
    u8 y;
    u8 spr;
    u8 opt;
} sprite_t;

typedef struct {
    u8 x;
    u8 y;
} scroll_t;

typedef struct {
    u8       ctrl;
    u8       mask;
    scroll_t scroll;
    u8       system;
} ppu_t;
#endif
#define null 0
#define true 1
#define false 0