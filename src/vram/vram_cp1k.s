    .importzp ptr1 
    .export _vram_cp1k 
    
    .segment "CODE"

    .proc _vram_cp1k 
    sta ptr1+0 
    stx ptr1+1 
    ldx #4
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
