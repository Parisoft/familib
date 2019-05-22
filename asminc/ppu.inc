	.importzp sp 
	
	.define PPUCTRL   	$2000
	.define PPUSTATUS 	$2002
	.define PPUSCROLL	$2005
	.define PPUADDR   	$2006
	.define PPUDATA   	$2007
	.define SCREEN_ROWS 30
	.define SCREEN_COLS 32
	.define SCREEN_WIDTH_TILES 32
	.define SCREEN_HEIGHT_TILES 30
	.define NAME_TABLE_TOP_LEFT $2000
	.define NAME_TABLE_TOP_RIGHT $2400
	.define NAME_TABLE_BOTTOM_LEFT $2800
	.define NAME_TABLE_BOTTOM_RIGHT $2C00
	.define SPRITE_BEHIND_BG %00100000
	.define SPRITE_MIRROR    %01000000
	.define SPRITE_FLIP      %10000000



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

	.define ppu_ctrl 		_ppu+ppu_t::ctrl
	.define ppu_mask 		_ppu+ppu_t::mask
	.define ppu_scroll		_ppu+ppu_t::scroll
	.define ppu_scroll_x	ppu_scroll+scroll_t::xoff
	.define ppu_scroll_y	ppu_scroll+scroll_t::yoff
	.define ppu_system		_ppu+ppu_t::system

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