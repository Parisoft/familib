#include "../../type.h"

// OAMADDR register
#define OAMADDR *((u8 *)0x2003)

// OAMDATA register
#define OAMDATA *((u8 *)0x2004)

// OAMDMA register
#define OAMDMA *((u8 *)0x4014)

// flush buffered sprites through DMA
#define oam_flush_sprites() \
    OAMADDR = 0x00;         \
    OAMDMA  = 0x02;

// buffer 1 sprite into OAM
void __fastcall__ oam_buffer_spr(u8 x, u8 y, u8 spr, u8 opt, u8 num);

// buffer a metasprito into OAM
// meta is an array of 4 byte arrays in the format: [x, y, spr, opt]
// the value $80 mark the end of the array
void __fastcall__ oam_buffer_metaspr(u8 x, u8 y, u8 num, const u8 *meta);

// hide all sprites from number to 63
void __fastcall__ oam_hide_sprites_from(u8 num);