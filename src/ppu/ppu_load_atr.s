    .include "ppu.inc"

ppu_load_atr = _ppu_load_atr

	; void __fastcall__ ppu_load_atr(const u8 *data);
	.proc _ppu_load_atr
	sta ppuptr1+0	; ptr1 = *data
	stx ppuptr1+1 
	ldy #0
@loop:
	lda (ppuptr1), y
	sta PPUDATA 
	iny 
	cpy #64
	bne @loop
	rts 
	.endproc
