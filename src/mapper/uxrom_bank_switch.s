    .include "uxrom.inc"

    .importzp _uxrom 
    .import _uxrom_banktable 
    .export _uxrom_bank_switch 

    .segment "CODE"

    .proc _uxrom_bank_switch 
    tax 
    sta uxrom_bank 
    sta _uxrom_banktable, x
    rts 
    .endproc