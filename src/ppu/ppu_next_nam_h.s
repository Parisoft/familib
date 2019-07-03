	.include "ppu.inc"

ppu_next_nam_h = _ppu_next_nam_h

	; u16 __fastcall__ ppu_next_nam_h();
	.proc _ppu_next_nam_h 
	lda ppu::ctrl
	and #%00000011
	eor #%00000001
	asl A 
	asl A 
	clc 
	adc #$20
	tax 
	lda #0
	rts 
	.endproc
