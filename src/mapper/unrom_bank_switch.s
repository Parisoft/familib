    .importzp _unrom 
    .import _unrom_banktable 
    .export _unrom_bank_switch 

    .segment "CODE"

    .proc _unrom_bank_switch 
    tax 
    sta _unrom 
    sta _unrom_banktable, x
    rts 
    .endproc