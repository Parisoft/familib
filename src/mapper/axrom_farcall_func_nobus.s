    .include "axrom.inc"

    .importzp _axrom, ptr4, tmp1, tmp2, tmp4 
    .export _axrom_farcall_func_nobus

    .proc _axrom_farcall_func_nobus
    ; preserve A/X args
    sta tmp1 
    stx tmp2 
    ; preserve axrom state
    lda axrom_bank 
    cmp tmp4 
    beq @callfunc
    pha 
    ; bank switch
    lda tmp4 
    sta axrom_bank 
    sta $8000
    ; call func
    lda tmp1 
    ldx tmp2 
    jsr @callfunc 
    ; preserve A/X return value
    sta tmp1 
    stx tmp2 
    ; restore axrom state
    pla 
    sta axrom_bank 
    sta $8000
    ; restore A/X return value
    lda tmp1 
    ldx tmp2 
    rts 
@callfunc:
    jmp (ptr4)
    .endproc