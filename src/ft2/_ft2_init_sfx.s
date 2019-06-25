    .include "ft2.inc"

    .segment "CODE"

    ; void __fastcall__ ft2_init_sfx(const u8 *data);
	.proc _ft2_init_sfx 
	pha 
	txa 
	tay		; Y = >data
	pla 
	tax 	; X = <data
	jmp FamiToneSfxInit 
	.endproc