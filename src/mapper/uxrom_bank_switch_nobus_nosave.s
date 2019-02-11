    .importzp _uxrom 
    .export _uxrom_bank_switch_nobus_nosave

    .segment "CODE"

    .proc _uxrom_bank_switch_nobus_nosave
    sta $8000
    rts 
    .endproc