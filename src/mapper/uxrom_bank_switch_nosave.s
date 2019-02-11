    .import _uxrom_banktable 
    .export _uxrom_bank_switch_nosave 

    .segment "CODE"
    
    ;void __fastcall__ uxrom_bank_switch_nosave(u8_t bank);
    .proc _uxrom_bank_switch_nosave 
    tax 
    sta _uxrom_banktable, x
    rts 
    .endproc