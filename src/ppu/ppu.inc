	.importzp sp 
	
	.define PPUCTRL   	$2000
	.define PPUSTATUS 	$2002
	.define PPUADDR   	$2006
	.define PPUDATA   	$2007
	.define SCREEN_ROWS 30
	.define SCREEN_COLS 32

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