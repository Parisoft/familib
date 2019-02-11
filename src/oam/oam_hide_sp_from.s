    .include "oam.inc"

    .export _oam_hide_sp_from 

    ; void __fastcall__ oam_hide_sp_from(u8 num);
    .proc _oam_hide_sp_from
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