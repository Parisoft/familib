    .include "ppu.inc"
    
ppu_load_atr_row_at = _ppu_load_atr_row_at

	; void __fastcall__ ppu_load_atr_row_at(u16 nt, u8 row, const u8 *data);
	.proc _ppu_load_atr_row_at
	sta ppuptr1+0	; ptr1 = *data
	stx ppuptr1+1 
	ldy #0
	lda (sp), y	; LDA row
	asl A 
	asl A 
	asl A 
	sta pputmp1 
	clc 
	adc #<$03C0
	tax 
	ldy #2
	lda (sp), Y	; LDA nt+1
	adc #>$03C0
	sta PPUADDR 
	stx PPUADDR 
	ldy pputmp1 
	ldx #8
@loop:
	lda (ppuptr1), y
	sta PPUDATA 
	iny 
	dex 
	bne @loop
	updsp 3
	rts 
	.endproc
