#include "def.h"

// OAM buffer address
#define OAMBUFF *((u8_t *)0x0200)

// OAM y position offset
#define OAM_Y_OFF *((u8_t *)0x0200)

// OAM x position offset
#define OAM_X_OFF *((u8_t *)0x0203)

// OAM fx offset
#define OAM_FX_OFF *((u8_t *)0x0202)

// OAM id  offset
#define OAM_ID_OFF *((u8_t *)0x0201)

// OAMADDR register
#define OAMADDR *((u8_t *)0x2003)

// OAMDATA register
#define OAMDATA *((u8_t *)0x2004)

// OAMDMA register
#define OAMDMA *((u8_t *)0x4014)

// flush buffered sprites through DMA
#define oam_dma()   \
    OAMADDR = 0x00; \
    OAMDMA  = 0x02;

// buffer 1 sprite into OAM
// return the next sp number
u8_t __fastcall__ oam_set_sp(u8_t x, u8_t y, u8_t sp, u8_t fx, u8_t num);

// buffer a metasprito into OAM
// meta is an array of 4 byte arrays in the format: [x, y, sp, fx]
// the value $80 mark the end of the array
// return the next sp number
u8_t __fastcall__ oam_set_metasp(u8_t x, u8_t y, u8_t num, const u8_t *meta);

// buffer a metasprito into OAM with additional effect
// meta is an array of 4 byte arrays in the format: [x, y, sp, fx]
// the value $80 mark the end of the array
// return the next sp number
u8_t __fastcall__ oam_set_metasp_fx(u8_t x, u8_t y, u8_t fx, u8_t num, const u8_t *meta);

// hide a given sprite
void __fastcall__ oam_hide_sp(u8_t num);

// hide all sprites from number to 63
void __fastcall__ oam_hide_sp_from(u8_t num);

// hide all sprites in range
// from is the 1st sprite in range (inclusive)
// to is the last sprite in range (exclusive)
void __fastcall__ oam_hide_sp_range(u8_t from, u8_t to);