    .include "ppu.inc"

    .importzp ppuptr1 
    .export _ppu_load_sp_pal_at 

	; void __fastcall__ ppu_load_sp_pal_at(u8 idx, const u8 *data);
	.proc _ppu_load_sp_pal_at 
	sta ppuptr1+0 
	stx ppuptr1+1 
	lda #>$3F10         
	sta PPUADDR      
	pop_a ; LDA idx
	asl A               
	asl A               
	clc                 
	adc #<$3F10         
	sta PPUADDR      
	ldy #0              
@loop:                 
	lda (ppuptr1), y  
	sta PPUDATA      
	iny                 
	cpy #4              
	bne @loop            
	rts 
	.endproc
