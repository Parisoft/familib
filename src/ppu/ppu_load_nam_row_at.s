    .include "ppu.inc"

ppu_load_nam_row_at = _ppu_load_nam_row_at

	; void __fastcall__ ppu_load_nam_row_at(u16 nt, u8 row, const u8 *data);
	.proc _ppu_load_nam_row_at
	sta ppuptr1+0	; ptr1 = *data
	stx ppuptr1+1 
	ldy #0
	lda (sp), y	; LDA row
	sty pputmp2	; tmp2 = >offset
	.repeat 5	; offset = row * 32
	asl A 
	rol pputmp2 
	.endrepeat
	sta pputmp1	; tmp1 = <offset
	clc 
	adc ppuptr1+0 
	sta ppuptr1+0 
	lda pputmp2 
	adc ppuptr1+1 
	sta ppuptr1+1 
	iny 
	lda (sp), y	; LDA nt+0
	clc 
	adc pputmp1 
	sta pputmp1	; tmp1 <nt
	iny 
	lda (sp), y	; LDA nt+1
	adc pputmp2 
	sta PPUADDR 
	lda pputmp1 
	sta PPUADDR 
	ldy #0
@loop:
	lda (ppuptr1), y 
	sta PPUDATA 
	iny 
	cpy #SCREEN_WIDTH_TILES
	bne @loop
	updsp 3
	rts 
	.endproc

