    .import _unrom_banktable 
    .export _unrom_bank_switch_stateless 

    .segment "CODE"

    .proc _unrom_bank_switch_stateless 
    tax 
    sta _unrom_banktable, x
    rts 
    .endproc