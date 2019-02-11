    .include "uxrom.inc"

    .importzp _uxrom 
    .export _uxrom_bank_switch_nobus

    .segment "CODE"

    .proc _uxrom_bank_switch_nobus
    sta uxrom_bank 
    sta $8000
    rts 
    .endproc