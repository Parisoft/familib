    .import _axrom_banktable 
    .export _axrom_bank_switch_nosave

    .segment "CODE"

    .proc _axrom_bank_switch_nosave
    tax 
    sta _axrom_banktable, x
    rts 
    .endproc