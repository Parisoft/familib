    .include "axrom.inc"

    .importzp _axrom, ptr4, tmp4 
    .export _axrom_farcall_proc_nobus

    .proc _axrom_farcall_proc_nobus
    ; preserve axrom state
    lda axrom_bank 
    cmp tmp4 
    beq @callproc 
    pha 
    ; bank switch
    lda tmp4 
    sta axrom_bank 
    sta $8000
    ; call func
    jsr @callproc
    ; restore axrom state
    pla 
    sta axrom_bank 
    sta $8000
    rts 
@callproc:
    jmp (ptr4)
    .endproc