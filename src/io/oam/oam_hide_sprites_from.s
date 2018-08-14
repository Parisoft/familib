    .export _oam_hide_sprites_from 

OAMBUFF = $0200
OAMADDR = $2003
OAMDATA = $2004
OAMDMA  = $4014

;extern void __fastcall__ oam_hide_sprites_from(u8 num);
.proc _oam_hide_sprites_from 
    asl A 
    asl A 
    tax 
    lda #$F0
@hide:
    sta OAMBUFF, x
    .repeat 4
    inx 
    .endrepeat
    bne @hide
    rts 
.endproc