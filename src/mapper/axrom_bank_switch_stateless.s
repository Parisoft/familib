    .import _axrom_banktable 
    .export _axrom_bank_switch_stateless 

    .segment "CODE"

    .proc _axrom_bank_switch_stateless 
    tax 
    sta _axrom_banktable, x
    rts 
    .endproc