    .include "ppu.inc"

ppu_load_atr_col_at = _ppu_load_atr_col_at

	; void __fastcall__ ppu_load_atr_col_at(u16 nt, u8 col, const u8 *data);
	.proc _ppu_load_atr_col_at
	sta ppuptr1+0	; ptr1 = *data
	stx ppuptr1+1 
	ldy #0
	lda (sp), y	    ; LDA col
	sta pputmp1	    ; tmp1 = col
	clc 
	adc #<$03C0
	sta ppuptr2+0   ; ptr2 = nt
	ldy #2
	lda (sp), y	    ; LDA nt+1
	adc #>$03C0
	sta ppuptr2+1	
	ldy pputmp1 
	ldx #8
@loop:
	sta PPUADDR 
	lda ppuptr2+0 
	sta PPUADDR 
	lda (ppuptr1), y
	sta PPUDATA 
	dex 
	beq @done
	tya 
	adc #8
	tay 
	lda ppuptr2+0 
	adc #8
	sta ppuptr2+0 
	lda ppuptr2+1 
	bne @loop
@done:
	updsp 3
	rts 
	.endproc
