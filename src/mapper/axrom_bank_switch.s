    .importzp _axrom 
    .import _axrom_banktable 
    .export _axrom_bank_switch 

    .segment "CODE"

    .proc _axrom_bank_switch 
    tax 
    sta _axrom 
    sta _axrom_banktable, x
    rts 
    .endproc