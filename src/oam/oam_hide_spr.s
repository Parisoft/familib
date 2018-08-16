	.export _oam_hide_spr 

OAMBUFF = $0200

; void __fastcall__ oam_hide_spr(u8 num);
.proc _oam_hide_spr 
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
