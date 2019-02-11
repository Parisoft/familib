    .include "ppu.inc"

    .importzp ppuptr1 
    .export _ppu_load_nt 

	; void __fastcall__ ppu_load_nt(u16 nt, const u8 *data);
	.proc _ppu_load_nt
	sta ppuptr1+0 
	stx ppuptr1+1 
	ldy #1
	lda (sp), y	; LDA nt+1    
	sta PPUADDR       
	dey 
	lda (sp), y	; LDA nt+0
	sta PPUADDR       
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
	updsp 1
	rts 
	.endproc
