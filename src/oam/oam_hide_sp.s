	.include "oam.inc"

    .export _oam_hide_sp

    ; void __fastcall__ oam_hide_sp(u8 num);
    .proc _oam_hide_sp
    asl a 
    asl a 
    tax 
    lda #$F0
	sta OAMBUFF+0, x 
	sta OAMBUFF+1, x 
	sta OAMBUFF+2, x 
	sta OAMBUFF+3, x 
    rts 
    .endproc
