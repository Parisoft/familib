    .include "ppu.inc"

ppu_load_nam_col_at = _ppu_load_nam_col_at

	; void __fastcall__ ppu_load_nam_col_at(u16 nt, u8 col, const u8 *data);
	.proc _ppu_load_nam_col_at
	sta ppuptr1+0	; ptr1 = *data
	stx ppuptr1+1 
	lda #%00000100	; vram inc by 32 going down
	sta PPUCTRL 
	ldy #2
	lda (sp), y	; LDA nt+1
	sta PPUADDR 
	dey 
	dey 
	lda (sp), y	; LDA col
	sta PPUADDR 
	ldx #SCREEN_HEIGHT_TILES	
@loop:
	clc 
	adc ppuptr1+0 
	sta ppuptr1+0 
	bcc @skip 
	inc ppuptr1+1 
@skip:
    lda (ppuptr1), y
	sta	PPUDATA 
	lda #SCREEN_WIDTH_TILES
	dex 
	bne @loop
	lda ppu::ctrl
	sta PPUCTRL 
	updsp 3
	rts 
	.endproc
