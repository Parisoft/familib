	.importzp sp
	.globalzp _ppu, ppuptr1, ppuptr2, pputmp1, pputmp2, pputmp3
	.global ppu_detect_system;()
	.global ppu_curr_nam;()
	.global ppu_next_nam_h;()
	.global ppu_next_nam_v;()
	.global ppu_load_bg_pal;(const u8_t *pal)
	.global ppu_load_bg_pal_at;(u8_t idx, const u8_t *pal)
	.global ppu_load_bg_pal_color;(u8_t idx, u8_t color)
	.global ppu_load_sp_pal;(const u8_t *pal)
	.global ppu_load_sp_pal_at;(u8_t idx, const u8_t *pal)
	.global ppu_load_sp_pal_color;(u8_t idx, u8_t color)
	.global ppu_load_nam;(const u8_t *nam)
	.global ppu_load_nam_at;(u16_t addr, const u8_t *nam)
	.global ppu_load_nam_tile_at;(u8_t tile, u16_t addr, u8_t row, u8_t col)
	.global ppu_load_nam_row_at;(u16_t addr, u8_t row, const u8_t *nam)
	.global ppu_load_nam_col_at;(u16_t addr, u8_t col, const u8_t *nam)
	.global ppu_load_nam_section_at;(u16_t addr, u8_t rowoff, u8_t coloff, u8_t rowlen, u8_t collen, const u8_t *section)
	.global ppu_unrle_nam;(const u8_t *data)
	.global ppu_unrle_nam_at;(u16_t addr, const u8_t *data)
	.global ppu_load_atr;(const u8_t *atr)
	.global ppu_load_atr_at;(u16_t addr, const u8_t *atr)
	.global ppu_load_atr_row_at;(u16_t addr, u8_t row, const u8_t *atr)
	.global ppu_load_atr_col_at;(u16_t addr, u8_t col, const u8_t *atr)
	.global ppu_load_atr_cell_at;(u8_t data, u16_t addr, u8_t row, u8_t col)
	; For C code
	.global _ppu_curr_nam
    .global _ppu_next_nam_h
    .global _ppu_next_nam_v
    .global _ppu_load_bg_pal
    .global _ppu_load_bg_pal_at
    .global _ppu_load_bg_pal_color
    .global _ppu_load_sp_pal
    .global _ppu_load_sp_pal_at
    .global _ppu_load_sp_pal_color
    .global _ppu_load_nam
    .global _ppu_load_nam_at
    .global _ppu_load_nam_tile_at
    .global _ppu_load_nam_row_at
    .global _ppu_load_nam_col_at
    .global _ppu_load_nam_section_at
    .global _ppu_unrle_nam
    .global _ppu_unrle_nam_at
    .global _ppu_load_atr
    .global _ppu_load_atr_at
    .global _ppu_load_atr_row_at
    .global _ppu_load_atr_col_at
    .global _ppu_load_atr_cell_at
	
	; Name table top left address
	.define NAME_TABLE_TOP_LEFT $2000

	; Name table top right address
	.define NAME_TABLE_TOP_RIGHT $2400

	; Name table bottom left address
	.define NAME_TABLE_BOTTOM_LEFT $2800

	; Name table bottom right address
	.define NAME_TABLE_BOTTOM_RIGHT $2C00

	; Number of pixels in one row of the screen
	.define SCREEN_WIDTH_PX 256

	; Number of pixels in one column of the screen
	.define SCREEN_HEIGHT_PX 240

	; Number of tiles in one row of the screen
	.define SCREEN_WIDTH_TILES 32

	; Number of tiles in one column of the screen
	.define SCREEN_HEIGHT_TILES 30

	; Option to drawn sprites behind background
	.define SPRITE_BEHIND_BG %00100000

	; Option to drawn sprites mirrored (flipped horizontally)
	.define SPRITE_MIRROR_H %01000000
	.define SPRITE_FLIP_H %01000000

	; Option to drawn the sprite flipped vertically
	.define SPRITE_FLIP_V %10000000
	.define SPRITE_MIRROR_V %10000000

	; PPUCTRL register
	.define PPUCTRL $2000

	; PPUMASK register
	.define PPUMASK $2001

	; PPUSTATUS register
	.define PPUSTATUS $2002

	; PPUSCROLL register
	.define PPUSCROLL $2005

	; PPUADDR register
	.define PPUADDR $2006

	; PPUDATA register
	.define PPUDATA $2007

	.macro ppu_set_nam_top_left
	lda ppu::ctrl
	and #$fc
	sta ppu::ctrl
	.endmac

	.macro ppu_set_nam_top_right
	lda ppu::ctrl
	and #$fc
	ora #1
	sta ppu::ctrl
	.endmac

	.macro ppu_set_nam_bot_left
	lda ppu::ctrl
	and #$fc
	ora #2
	sta ppu::ctrl
	.endmac

	.macro ppu_set_nam_bot_right
	lda ppu::ctrl
	ora #3
	sta ppu::ctrl
	.endmac

	.macro ppu_set_vram_inc_by_1
	lda ppu::ctrl
	and #$fb
	sta ppu::ctrl
	.endmac

	.macro ppu_set_vram_inc_by_32
	lda ppu::ctrl
	ora #4
	sta ppu::ctrl
	.endmac

	.macro ppu_set_sp_at_left_pattern_table
	lda ppu::ctrl
	and #$f7
	sta ppu::ctrl
	.endmac

	.macro ppu_set_sp_at_right_pattern_table
	lda ppu::ctrl
	ora #8
	sta ppu::ctrl
	.endmac

	.macro ppu_set_bg_at_left_pattern_table
	lda ppu::ctrl
	and #$ef
	sta ppu::ctrl
	.endmac

	.macro ppu_set_bg_at_right_pattern_table
	lda ppu::ctrl
	ora #$10
	sta ppu::ctrl
	.endmac

	.macro ppu_set_sp_8x8
	lda ppu::ctrl
	and #$df
	sta ppu::ctrl
	.endmac

	.macro ppu_set_sp_8x16
	lda ppu::ctrl
	ora #$20
	sta ppu::ctrl
	.endmac

	.macro ppu_set_master_mode_on
	lda ppu::ctrl
	and #$bf
	sta ppu::ctrl
	.endmac

	.macro ppu_set_mater_mode_off
	lda ppu::ctrl
	ora #$40
	sta ppu::ctrl
	.endmac

	.macro ppu_set_nmi_on
	lda ppu::ctrl
	ora #$80
	sta ppu::ctrl
	.endmac

	.macro ppu_set_nmi_off
	lda ppu::ctrl
	and #$7f
	sta ppu::ctrl
	.endmac

	.macro ppu_set_greyscale_on
	lda ppu::mask
	ora #1
	sta ppu::mask
	.endmac

	.macro ppu_set_greyscale_off
	lda ppu::mask
	and #$fe
	sta ppu::mask
	.endmac

	.macro ppu_set_bg_left_col_on
	lda ppu::mask
	ora #2
	sta ppu::mask
	.endmac

	.macro ppu_set_bg_left_col_off
	lda ppu::mask
	and #$fd
	sta ppu::mask
	.endmac

	.macro ppu_set_sp_left_col_on
	lda ppu::mask
	ora #4
	sta ppu::mask
	.endmac

	.macro ppu_set_sp_left_col_off
	lda ppu::mask
	and #$fb
	sta ppu::mask
	.endmac

	.macro ppu_set_bg_on
	lda ppu::mask
	ora #8
	sta ppu::mask
	.endmac

	.macro ppu_set_bg_off
	lda ppu::mask
	and #$f7
	sta ppu::mask
	.endmac

	.macro ppu_set_sp_on
	lda ppu::mask
	ora #$10
	sta ppu::mask
	.endmac

	.macro ppu_set_sp_off
	lda ppu::mask
	and #$ef
	sta ppu::mask
	.endmac

	.macro ppu_set_red_emphasis_on
	lda ppu::mask
	ora #$20
	sta ppu::mask
	.endmac

	.macro ppu_set_red_emphasis_off
	lda ppu::mask
	and #$df
	sta ppu::mask
	.endmac

	.macro ppu_set_green_emphasis_on
	lda ppu::mask
	ora #$40
	sta ppu::mask
	.endmac

	.macro ppu_set_green_emphasis_off
	lda ppu::mask
	and #$bf
	sta ppu::mask
	.endmac

	.macro ppu_set_blue_emphasis_on
	lda ppu::mask
	ora #$80
	sta ppu::mask
	.endmac

	.macro ppu_set_blue_emphasis_off
	lda ppu::mask
	and #$7f
	sta ppu::mask
	.endmac

	.macro ppu_set_rendering_on
	lda ppu::mask
	ora #$18
	sta ppu::mask
	.endmac

	.macro ppu_set_rendering_off
	lda ppu::mask
	and #$e7
	sta ppu::mask
	.endmac

	.macro ppu_rendering
	lda ppu::mask
	and #$18
	.endmac

	; swaps name tables horizontally
	.macro ppu_swap_nam_h
	lda ppu::ctrl
	eor #1
	sta ppu::ctrl
	.endmac

	; swaps name tables vertically
	.macro ppu_swap_nam_v
	lda ppu::ctrl
	eor #2
	sta ppu::ctrl
	.endmac

	; wait for a vblank to happen
	.macro ppu_wait_vblank
	.local wait_vblank
wait_vblank:
	bit $2002
	bpl wait_vblank
	.endmac

	; wait for the sprite 0 hit to happen
	.macro ppu_wait_sp0_hit
	.local clear_hit, wait_hit
clear_hit:
	bit $2002
	bvs clear_hit
wait_hit:
	bit $2002
	bvc wait_hit
	.endmac

	.macro ppu_wait_sp_overflow
	.local clear_overflow, wait_overflow
clear_overflow:
	lda $2002
	and #%00100000
	bne clear_overflow
wait_overflow:
	lda $2002
	and #%00100000
	beq wait_overflow
	.endmac

	.macro ppu_update
	lda #0
	sta PPUADDR           
	sta PPUADDR           
	lda ppu::scroll::xoff
	sta PPUSCROLL
	lda ppu::scroll::yoff
	sta PPUSCROLL
	lda ppu::ctrl
	sta PPUCTRL
	lda ppu::mask
	sta PPUMASK
	.endmac

	.struct scroll_t
	xoff	.res 1
	yoff	.res 1
	.endstruct

	.struct ppu_t
	ctrl	.res 1
	mask	.res 1
	scroll	.tag scroll_t
	system	.res 1
	.endstruct

	.scope ppu
	ctrl 	 = _ppu+ppu_t::ctrl
	mask 	 = _ppu+ppu_t::mask
	system	 = _ppu+ppu_t::system
		.scope scroll
		xoff = _ppu+ppu_t::scroll+scroll_t::xoff
		yoff = _ppu+ppu_t::scroll+scroll_t::yoff
		.endscope
	.endscope

	.macro pop_a 
	LDY #0
	LDA (sp), Y 
	INC sp 
	BNE :+ 
	INC sp+1 
:
	.endmac

	.macro updsp n 
	CLC 
	LDA sp+0 
	ADC #n 
	STA sp+0 
	BCC :+ 
	INC sp+1
: 
	.endmac