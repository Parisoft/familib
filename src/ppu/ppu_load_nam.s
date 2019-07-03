    .include "ppu.inc"

ppu_load_nam = _ppu_load_nam

	; void __fastcall__ ppu_load_nam(const u8 *data);
	.proc _ppu_load_nam
	sta ppuptr1+0 
	stx ppuptr1+1 
	ldy #0       
	ldx #3               
@loop:                  
	lda (ppuptr1), y 
	sta PPUDATA       
	iny                  
	bne @loop            
	inc ppuptr1+1 
	dex                  
	bne @loop            
@frag:                  
	lda (ppuptr1), y 
	sta PPUDATA       
	iny                  
	cpy #$C0             
	bne @frag  
	rts 
	.endproc
