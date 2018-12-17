    .import _axrom, _axrom_banktable 
    .importzp ptr4, tmp1, tmp2, tmp4 
    .export _axrom_farcall_supp 

    .proc _axrom_farcall_supp 
    ; preserve axrom state
    lda _axrom 
    cmp tmp4 
    beq @callsup
    pha 
    ; bank switch
    lda tmp4 
    tax 
    sta _axrom 
    sta _axrom_banktable, x
    ; call func
    jsr @callsup 
    ; preserve A/X return value
    sta tmp1 
    stx tmp2 
    ; restore axrom state
    pla 
    tax 
    sta _axrom 
    sta _axrom_banktable, x
    ; restore A/X return value
    lda tmp1 
    ldx tmp2 
    rts 
@callsup:
    jmp (ptr4)
    .endproc