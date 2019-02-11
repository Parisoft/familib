    .export _axrom_bank_switch_nobus_nosave

    .segment "CODE"

    .proc _axrom_bank_switch_nobus_nosave
    sta $8000
    rts 
    .endproc