    .include "mmc3.inc"
    
    .importzp _mmc3 
    .export _mmc3_slot_select_at 

    ;void __fastcall__ mmc3_slot_select_at(u8_t idx)
    .proc _mmc3_slot_select_at 
    sta mmc3_slot
    ora mmc3_mode 
    sta MMC3_BANKSELECT 
    rts 
    .endproc