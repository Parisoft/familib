    .include "axrom.inc"
    
    .importzp _axrom, ptr4, tmp1, tmp2, tmp4 
    .import _axrom_banktable 
    .export _axrom_farcall_cons 

    .proc _axrom_farcall_cons 
    ; preserve A/X args
    sta tmp1 
    stx tmp2 
    ; preserve axrom state
    lda axrom_bank 
    cmp tmp4 
    beq @callcons
    pha 
    ; bank switch
    lda tmp4 
    tax 
    sta axrom_bank 
    sta _axrom_banktable, x
    ; call func
    lda tmp1 
    ldx tmp2 
    jsr @callcons
    ; restore axrom state
    pla 
    tax 
    sta axrom_bank 
    sta _axrom_banktable, x
    rts 
@callcons:
    jmp (ptr4)
    .endproc
