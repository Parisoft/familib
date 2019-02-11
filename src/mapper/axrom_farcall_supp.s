    .include "axrom.inc"
    
    .importzp _axrom, ptr4, tmp1, tmp2, tmp4 
    .import _axrom_banktable 
    .export _axrom_farcall_supp 

    .proc _axrom_farcall_supp 
    ; preserve axrom state
    lda axrom_bank 
    cmp tmp4 
    beq @callsup
    pha 
    ; bank switch
    lda tmp4 
    tax 
    sta axrom_bank 
    sta _axrom_banktable, x
    ; call func
    jsr @callsup 
    ; preserve A/X return value
    sta tmp1 
    stx tmp2 
    ; restore axrom state
    pla 
    tax 
    sta axrom_bank 
    sta _axrom_banktable, x
    ; restore A/X return value
    lda tmp1 
    ldx tmp2 
    rts 
@callsup:
    jmp (ptr4)
    .endproc