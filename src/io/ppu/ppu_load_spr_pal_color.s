    .export _ppu_load_spr_pal_color 

    .include "ppu.inc"

; void __fastcall__ ppu_load_spr_pal_color(u8 idx, u8 color);
.proc _ppu_load_spr_pal_color 
	tax 
	lda #>$3F10    
	sta PPUADDR 
	pop_a ; LDA idx 
	clc            
	adc #<$3F10    
	sta PPUADDR 
	stx PPUDATA 
	rts 
.endproc
