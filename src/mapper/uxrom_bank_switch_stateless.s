    .import _uxrom_banktable 
    .export _uxrom_bank_switch_stateless 

    .segment "CODE"

    .proc _uxrom_bank_switch_stateless 
    tax 
    sta _uxrom_banktable, x
    rts 
    .endproc