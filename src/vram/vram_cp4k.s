    .segment "PRG00"
    .importzp ptr1 
    .export _vram_cp4k 
    
    .proc _vram_cp4k 
    sta ptr1+0 
    stx ptr1+1 
    ldx #16
    ldy #0
@copy:
    lda (ptr1), y
    sta $2007
    iny 
    bne @copy
    inc ptr1+1 
    dex 
    bne @copy
    rts 
    .endproc
