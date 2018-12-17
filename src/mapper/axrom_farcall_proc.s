    .import _axrom_banktable 
    .importzp _axrom, ptr4, tmp4 
    .export _axrom_farcall_proc 

    .proc _axrom_farcall_proc 
    ; preserve axrom state
    lda _axrom 
    cmp tmp4 
    beq @callproc 
    pha 
    ; bank switch
    lda tmp4 
    tax 
    sta _axrom 
    sta _axrom_banktable, x
    ; call func
    jsr @callproc
    ; restore axrom state
    pla 
    tax 
    sta _axrom 
    sta _axrom_banktable, x
    rts 
@callproc:
    jmp (ptr4)
    .endproc