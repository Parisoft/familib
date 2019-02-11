    .include "ppu.inc"

    .importzp ppuptr1 
    .export _ppu_load_sp_pal 

	; void __fastcall__ ppu_load_sp_pal(const u8 *data);
	.proc _ppu_load_sp_pal 
	sta ppuptr1+0 
	stx ppuptr1+1 
	lda #>$3F10         
	sta PPUADDR      
	lda #<$3F10         
	sta PPUADDR      
	ldy #0            
@loop:                 
	lda (ppuptr1), y 
	sta PPUDATA      
	iny                 
	cpy #16            
	bne @loop           
	rts 
	.endproc
