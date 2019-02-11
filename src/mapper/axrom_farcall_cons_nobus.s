    .include "axrom.inc"
    
    .importzp _axrom, ptr4, tmp1, tmp2, tmp4 
    .export _axrom_farcall_cons_nobus

    .proc _axrom_farcall_cons_nobus
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
    sta axrom_bank
    sta $8000
    ; call func
    lda tmp1 
    ldx tmp2 
    jsr @callcons
    ; restore axrom state
    pla 
    sta axrom_bank
    sta $8000
    rts 
@callcons:
    jmp (ptr4)
    .endproc
