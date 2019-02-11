	.include "ppu.inc"

    .importzp _ppu 
    .export _ppu_curr_nt

	; u16 __fastcall__ ppu_curr_nt();
	.proc _ppu_curr_nt
	lda ppu_ctrl 
	and #%00000011
	asl A 
	asl A 
	clc 
	adc #$20
	tax 
	lda #0
	rts 
	.endproc
