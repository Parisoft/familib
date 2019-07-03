    .include "vram.inc"    

vram_cpy1k = _vram_cpy1k

    .proc _vram_cpy1k 
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
