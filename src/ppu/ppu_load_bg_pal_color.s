    .include "ppu.inc"

    .export _ppu_load_bg_pal_color 

	; void __fastcall__ ppu_load_bg_pal_color(u8 idx, u8 color);
	.proc _ppu_load_bg_pal_color 
	tax 
	lda #>$3F00   
	sta PPUADDR 
	pop_a ; LDA idx     
	clc           
	adc #<$3F00   
	sta PPUADDR 
	stx PPUDATA 
	rts 
	.endproc
