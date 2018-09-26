    .importzp _mmc3 
    .export _mmc3_bank_select_at 
    .include "mmc3.inc"

;void __fastcall__ mmc3_bank_select_at(u8_t idx)
.proc _mmc3_bank_select_at 
    sta mmc3_index 
    ora mmc3_mode 
    sta MMC3_BANKSELECT  
.endproc