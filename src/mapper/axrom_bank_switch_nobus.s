    .include "axrom.inc"
    
    .importzp _axrom 
    .export _axrom_bank_switch_nobus

    .segment "CODE"

    .proc _axrom_bank_switch_nobus
    sta axrom_bank 
    sta $8000
    rts 
    .endproc