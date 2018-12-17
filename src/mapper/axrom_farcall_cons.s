    .import _axrom, _axrom_banktable 
    .importzp ptr4, tmp1, tmp2, tmp4 
    .export _axrom_farcall_cons 

    .proc _axrom_farcall_cons 
    ; preserve A/X args
    sta tmp1 
    stx tmp2 
    ; preserve axrom state
    lda _axrom 
    cmp tmp4 
    beq @callcons
    pha 
    ; bank switch
    lda tmp4 
    tax 
    sta _axrom 
    sta _axrom_banktable, x
    ; call func
    lda tmp1 
    ldx tmp2 
    jsr @callcons
    ; restore axrom state
    pla 
    tax 
    sta _axrom 
    sta _axrom_banktable, x
    rts 
@callcons:
    jmp (ptr4)
    .endproc
