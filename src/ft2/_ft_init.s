    .include "ft2.inc"
    .include "ppu.inc"

    .importzp _ppu

    .segment "CODE"

    ; void __fastcall__ ft2_init(const u8 *data);
	.proc _ft2_init 
	pha 
	txa 
	tay		; Y = >data
	pla 
	tax 	; X = <data
	lda ppu_system 
	jmp FamiToneInit 
	.endproc