    .include "ppu.inc"

ppu_load_atr_at = _ppu_load_atr_at

	; void __fastcall__ ppu_load_atr_at(u16 nt, const u8 *data);
	.proc _ppu_load_atr_at
	sta ppuptr1+0	; ptr1 = *data
	stx ppuptr1+1 
	ldy #1
	lda (sp), y	; LDA nt+1
	clc 
	adc #>$03C0
	sta PPUADDR 
	lda #<$03C0
	sta PPUADDR 
	dey 
@loop:
	lda (ppuptr1), y
	sta PPUDATA 
	iny 
	cpy #64
	bne @loop
	updsp 2
	rts 
	.endproc
