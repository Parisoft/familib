    .export _oam_hide_sprites_from 

OAMBUFF = $0200
OAMADDR = $2003
OAMDATA = $2004
OAMDMA  = $4014

; void __fastcall__ oam_hide_sprites_from(u8 num);
.proc _oam_hide_sprites_from 
    asl A 
    asl A 
    tax 
    lda #$FE
@hide:
    sta OAMBUFF+0, x
    sta OAMBUFF+1, x
    sta OAMBUFF+2, x
    sta OAMBUFF+3, x
    .repeat 4
    inx 
    .endrep
    bne @hide
    rts 
.endproc