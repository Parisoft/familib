    .include "mmc3.inc"
    
    .importzp _mmc3 
    .export _mmc3_bank_switch_at 

    ;void __fastcall__ mmc3_bank_switch_at(u8_t num)
    .proc _mmc3_bank_switch_at 
    ldx mmc3_slot
    sta mmc3_bank, x
    sta MMC3_BANKSWITCH 
    rts 
    .endproc