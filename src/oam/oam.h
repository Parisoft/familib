#include "../def/def.h"

// OAMADDR register
#define OAMADDR *((u8_t *)0x2003)

// OAMDATA register
#define OAMDATA *((u8_t *)0x2004)

// OAMDMA register
#define OAMDMA *((u8_t *)0x4014)

// flush buffered sprites through DMA
#define oam_flush_sprites() \
    OAMADDR = 0x00;         \
    OAMDMA  = 0x02;

// buffer 1 sprite into OAM
void __fastcall__ oam_buffer_spr(u8_t x, u8_t y, u8_t spr, u8_t opt, u8_t num);

// buffer a metasprito into OAM
// meta is an array of 4 byte arrays in the format: [x, y, spr, opt]
// the value $80 mark the end of the array
void __fastcall__ oam_buffer_metaspr(u8_t x, u8_t y, u8_t num, const u8_t *meta);

// hide a given sprite
void __fastcall__ oam_hide_spr(u8_t num);

// hide all sprites from number to 63
void __fastcall__ oam_hide_sprites_from(u8_t num);