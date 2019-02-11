    .include "ppu.inc"

	.importzp _ppu 
    .export _ppu_next_nt_v 

	; u16 __fastcall__ ppu_next_nt_v();
	.proc _ppu_next_nt_v 
	lda ppu_ctrl
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