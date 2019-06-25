    .include "ft2.inc"

    .segment "CODE"

    ; void __fastcall__ ft2_init_palm(const u8 *data);
	.proc _ft2_init_palm 
	pha 
	txa 
	tay		; Y = >data
	pla 
	tax 	; X = <data
	lda #0 
	jmp FamiToneInit 
	.endproc