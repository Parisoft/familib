#include "../../type.h"

// Name table top left address
#define NAME_TABLE_TOP_LEFT 0x2000

// Name table top right adderss
#define NAME_TABLE_TOP_RIGHT 0x2400

// Name table bottom left address
#define NAME_TABLE_BOTTOM_LEFT 0x2800

// Name table bottom right address
#define NAME_TABLE_BOTTOM_RIGHT 0x2C00

// Number of pixels in one row of the screen
#define SCREEN_WIDTH_PX 256

// Number of pixels in one column of the screen
#define SCREEN_HEIGHT_PX 240

// Number of tiles in one row of the screen
#define SCREEN_WIDTH_TILES 32

// Number of tiles in one column of the screen
#define SCREEN_HEIGHT_TILES 30

// Option to drawn sprites behind background
#define SPRITE_BEHIND_BG (1 << 5)

// Option to drawn sprites mirrored (flipped horizontally)
#define SPRITE_MIRROR (1 << 6)

// Option to drawn the sprite flipped vertically
#define SPRITE_FLIP (1 << 7)

// PPUCTRL register
#define PPUCTRL *((u8 *)0x2000)

// PPUMASK register
#define PPUMASK *((u8 *)0x2001)

// PPUSTATUS register
#define PPUSTATUS *((u8 *)0x2002)

// PPUSCROLL register
#define PPUSCROLL *((u8 *)0x2005)

// PPUADDR register
#define PPUADDR *((u8 *)0x2006)

// PPUDATA register
#define PPUDATA *((u8 *)0x2007)

extern ppu_t ppu;
#pragma zpsym("ppu");

#define ppu_set_name_table_top_left() ppu.ctrl = ppu.ctrl & 0xFC;

#define ppu_set_name_table_top_right() ppu.ctrl = (ppu.ctrl & 0xFC) | 0x01;

#define ppu_set_name_table_bot_left() ppu.ctrl = (ppu.ctrl & 0xFC) | 0x02;

#define ppu_set_name_table_bot_right() ppu.ctrl = ppu.ctrl | 0x03;

#define ppu_set_vram_inc_by_1_going_accross() ppu.ctrl = ppu.ctrl & 0xFB;

#define ppu_set_vram_inc_by_32_going_down() ppu.ctrl = ppu.ctrl | 0x04;

#define ppu_set_spr_at_left_pattern_table() ppu.ctrl = ppu.ctrl & 0xF7;

#define ppu_set_spr_at_right_pattern_table() ppu.ctrl = ppu.ctrl | 0x08;

#define ppu_set_bg_at_left_pattern_table() ppu.ctrl = ppu.ctrl & 0xEF;

#define ppu_set_bg_at_right_pattern_table() ppu.ctrl = ppu.ctrl | 0x10;

#define ppu_set_spr_8x8() ppu.ctrl = ppu.ctrl & 0xDF;

#define ppu_set_spr_8x16() ppu.ctrl = ppu.ctrl | 0x20;

#define ppu_set_master_mode_on() ppu.ctrl = ppu.ctrl & 0xBF;

#define ppu_set_mater_mode_off() ppu.ctrl = ppu.ctrl | 0x40;

#define ppu_set_nmi_on() ppu.ctrl = ppu.ctrl | 0x80;

#define ppu_set_nmi_off() ppu.ctrl = ppu.ctrl & 0x7F;

#define ppu_set_greyscale_on() ppu.mask = ppu.mask | 0x01;

#define ppu_set_greyscale_off() ppu.mask = ppu.mask & 0xFE;

#define ppu_set_bg_left_col_on() ppu.mask = ppu.mask | 0x02;

#define ppu_set_bg_left_col_off() ppu.mask = ppu.mask & 0xFD;

#define ppu_set_spr_left_col_on() ppu.mask = ppu.mask | 0x04;

#define ppu_set_spr_left_col_off() ppu.mask = ppu.mask & 0xFB;

#define ppu_set_bg_on() ppu.mask = ppu.mask | 0x08;

#define ppu_set_bg_off() ppu.mask = ppu.mask & 0xF7;

#define ppu_set_spr_on() ppu.mask = ppu.mask | 0x10;

#define ppu_set_spr_off() ppu.mask = ppu.mask & 0xEF;

#define ppu_set_red_emphasis_on() ppu.mask = ppu.mask | 0x20;

#define ppu_set_red_emphasis_off() ppu.mask = ppu.mask & 0xDF;

#define ppu_set_green_emphasis_on() ppu.mask = ppu.mask | 0x40;

#define ppu_set_green_emphasis_off() ppu.mask = ppu.mask & 0xBF;

#define ppu_set_blue_emphasis_on() ppu.mask = ppu.mask | 0x80;

#define ppu_set_blue_emphasis_off() ppu.mask = ppu.mask & 0x7F;

// swaps name tables horizontally
#define ppu_swap_name_tables_h() ppu.ctrl = ppu.ctrl ^ 1;

// swaps name tables vertically
#define ppu_swap_name_tables_v() ppu.ctrl = ppu.ctrl ^ 2;

// wait for a vblank to happen
#define ppu_wait_vblank() \
    wait_vblank:          \
    __asm__("bit $2002"); \
    __asm__("bpl %g", wait_vblank);

// wait for the sprite 0 hit to happen
#define ppu_wait_spr0_hit()       \
    clear_hit:                    \
    __asm__("bit $2002");         \
    __asm__("bvs %g", clear_hit); \
    wait_hit:                     \
    __asm__("bit $2002");         \
    __asm__("bvc %g", wait_hit);

#define ppu_update()          \
    PPUADDR   = 0;            \
    PPUADDR   = 0;            \
    PPUCTRL   = ppu.ctrl;     \
    PPUMASK   = ppu.mask;     \
    PPUSCROLL = ppu.scroll.x; \
    PPUSCROLL = ppu.scroll.y;

// detect the system region: NTSC or PAL
extern void ppu_detect_system();

// get current name table addr
extern u16 ppu_curr_name_table();

// get next horizontal name table addr
extern u16 ppu_next_name_table_h();

// get next vertical name table addr
extern u16 ppu_next_name_table_v();

// set 16 bg palette colors
extern void __fastcall__ ppu_load_bg_pal(const u8 *data);

// set 4 bg palette colors at index
extern void __fastcall__ ppu_load_bg_pal_at(u8 idx, const u8 *data);

// set 1 bg palette color
extern void __fastcall__ ppu_load_bg_pal_color(u8 idx, u8 color);

// set 16 spr palette colors
extern void __fastcall__ ppu_load_spr_pal(const u8 *data);

// set 4 spr palette colors at index
extern void __fastcall__ ppu_load_spr_pal_at(u8 idx, const u8 *data);

// set 1 spr palette color
extern void __fastcall__ ppu_load_spr_pal_color(u8 idx, u8 color);

// set name table
// nt is a name table addr
// data is a 960 bytes table
extern void __fastcall__ ppu_load_name_table(u16 nt, const u8 *data);

// set 1 name table tile
// nt is a name table addr
extern void __fastcall__ ppu_load_name_table_tile(u8 tile, u16 nt, u8 row, u8 col);

// set a name table row
// nt is a name table addr
// data is a 960 bytes table
extern void __fastcall__ ppu_load_name_table_row(u16 nt, u8 row, const u8 *data);

// set a name table column
// nt is a name table addr
// data is 960 bytes table
extern void __fastcall__ ppu_load_name_table_col(u16 nt, u8 col, const u8 *data);

// set a name table section
// nt is a name table addr
// row and col are the offset on screen
// len0 and len1 are the lengths of the section
// section is an arbitrary length 2D array of bytes
extern void __fastcall__ ppu_load_name_table_section(u16 nt, u8 row, u8 col, u8 len0, u8 len1, const u8 *section);

// set attribute table
// nt is a name table addr
// data is 64 bytes table
extern void __fastcall__ ppu_load_attr_table(u16 nt, const u8 *data);

// set an attribute table row
// nt is a name table addr
// data is 65 bytes table
extern void __fastcall__ ppu_load_attr_table_row(u16 nt, u8 row, const u8 *data);

// set an attribute table col
// nt is a name table addr
// data is 65 bytes table
extern void __fastcall__ ppu_load_attr_table_col(u16 nt, u8 col, const u8 *data);

// set an attribute cell
// nt is a name table addr
extern void __fastcall__ ppu_load_attr_table_cell(u8 data, u16 nt, u8 row, u8 col);
