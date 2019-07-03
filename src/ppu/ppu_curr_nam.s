	.include "ppu.inc"

ppu_curr_nam = _ppu_curr_nam

	; u16 __fastcall__ ppu_curr_nam();
	.proc _ppu_curr_nam
	lda ppu::ctrl 
	and #%00000011
	asl A 
	asl A 
	clc 
	adc #$20
	tax 
	lda #0
	rts 
	.endproc
