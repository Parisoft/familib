    .include "ppu.inc"

ppu_load_nam_tile_at = _ppu_load_nam_tile_at

	; void __fastcall__ ppu_load_nam_tile_at(u8 tile, u16 nt, u8 row, u8 col);
	.proc _ppu_load_nam_tile_at
	sta pputmp1	; tmp1 = col 
	ldy #0
	sty pputmp2 
	lda (sp), y	; LDA row
	.repeat 5	; row *= 32
	asl A 
	rol pputmp2 
	.endrepeat
	clc 		; row += col
	adc pputmp1 
	sta pputmp1 
	lda #0
	adc pputmp2 
	sta pputmp2 
	iny 
	lda (sp), y	; LDA nt+0
	clc 
	adc pputmp1 
	sta pputmp1 
	iny 
	lda (sp), y	; LDA nt+1 
	adc pputmp2 
	sta PPUADDR             
	lda pputmp1        
	sta PPUADDR        
	iny 
	lda (sp), y	; LDA tile                
	sta PPUDATA    
	updsp 4         
	rts 
	.endproc
