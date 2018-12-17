    .import _axrom_banktable 
    .importzp _axrom, ptr4, tmp1, tmp2, tmp4 
    .export _axrom_farcall_func 

    .proc _axrom_farcall_func 
    ; preserve A/X args
    sta tmp1 
    stx tmp2 
    ; preserve axrom state
    lda _axrom 
    cmp tmp4 
    beq @callfunc
    pha 
    ; bank switch
    lda tmp4 
    tax 
    sta _axrom 
    sta _axrom_banktable, x
    ; call func
    lda tmp1 
    ldx tmp2 
    jsr @callfunc 
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
@callfunc:
    jmp (ptr4)
    .endproc