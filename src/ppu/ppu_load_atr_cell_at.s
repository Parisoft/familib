    .include "ppu.inc"

ppu_load_atr_cell_at = _ppu_load_atr_cell_at    

	; void __fastcall__ ppu_load_atr_cell_at(u8 data, u16 nt, u8 row, u8 col);
	.proc _ppu_load_atr_cell_at
	sta pputmp1	; tmp1 = col
	ldy #0
	lda (sp), y	; LDA row
	asl A 
	asl A 
	asl A 
	clc 
	adc pputmp1 
	adc #<$03C0
	sta pputmp2	; tmp2 = <nt
	ldy #2
	lda (sp), Y	; LDA nt+1
	adc #>$03C0
	sta PPUADDR 
	lda pputmp2	
	sta	PPUADDR 
	iny 
	lda (sp), y	; LDA data
	sta PPUDATA 
	updsp 4
	rts 
	.endproc
