    .include "axrom.inc"

    .importzp _axrom, ptr4, tmp4 
    .import _axrom_banktable 
    .export _axrom_farcall_proc 

    .proc _axrom_farcall_proc 
    ; preserve axrom state
    lda axrom_bank 
    cmp tmp4 
    beq @callproc 
    pha 
    ; bank switch
    lda tmp4 
    tax 
    sta axrom_bank 
    sta _axrom_banktable, x
    ; call func
    jsr @callproc
    ; restore axrom state
    pla 
    tax 
    sta axrom_bank 
    sta _axrom_banktable, x
    rts 
@callproc:
    jmp (ptr4)
    .endproc