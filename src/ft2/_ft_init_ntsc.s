    .include "ft2.inc"

    .segment "CODE"

    ; void __fastcall__ ft2_init_ntsc(const u8 *data);
	.proc _ft2_init_ntsc 
	pha 
	txa 
	tay		; Y = >data
	pla 
	tax 	; X = <data
	lda #1 
	jmp FamiToneInit 
	.endproc