    .include "ppu.inc"

ppu_load_nam_section_at = _ppu_load_nam_section_at

	; void __fastcall__ ppu_load_nam_section_at(u16 nt, u8 row, u8 col, u8 len0, u8 len1, const u8 *section);
	.proc _ppu_load_nam_section_at
	sta ppuptr1+0	; ptr1 = *section
	stx ppuptr1+1 
	ldy #0		; 6 popa from len1 to nt
	lda (sp), y	; LDA len1
	sta pputmp3	; tmp3 = len1
	iny 
	lda (sp), y	; LDA len0
	tax	        ; X = len0
	iny 
	lda (sp), y	; LDA col
	sta pputmp1	; tmp1 = col 
	lda #0
	sta pputmp2 
	iny 
	lda (sp), y	; LDA row
	.repeat 5	; row *= 32
	asl A 
	rol pputmp2 
	.endrepeat
	clc 		; row += col
	adc pputmp1	; tmp1 = <offset
	sta pputmp1 
	lda #0
	adc pputmp2 ; tmp2 = >offset
	sta pputmp2 
	iny 
	lda (sp), y     ; LDA nt+0
	clc 
	adc pputmp1 
	sta ppuptr2+0   ; ptr2 = nt + offset
	iny 
	lda (sp), y     ; LDA nt+1
	adc pputmp2 	
	sta ppuptr2+1 
	bne @loop1	; BRA
@loop0:
	clc 
	lda ppuptr1+0 
	adc pputmp3	 
	sta ppuptr1+0 
	bcc @skip
	inc ppuptr1+1 
	clc 
@skip:
	lda ppuptr2+0 
	adc #SCREEN_WIDTH_TILES
	sta ppuptr2+0 
	lda ppuptr2+1 
	adc #0
	sta ppuptr2+1 
@loop1:
	sta PPUADDR 
	lda ppuptr2+0 
	sta PPUADDR 
	ldy #0
@loop2:
	lda (ppuptr1), Y 
	sta PPUDATA 
	iny 
	cpy pputmp3 
	bne @loop2
	dex 
	bne @loop0
	updsp 6
	rts 
	.endproc
