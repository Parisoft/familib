    .include "ppu.inc"

ppu_next_nam_v = _ppu_next_nam_v

	; u16 __fastcall__ ppu_next_nam_v();
	.proc _ppu_next_nam_v 
	lda ppu::ctrl
	and #%00000011
	eor #%00000010
	asl A 
	asl A 
	clc 
	adc #$20
	tax 
	lda #0
	rts 
	.endproc