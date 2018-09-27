    .importzp _mmc3 
    .export _mmc3_bank_switch_at 
    .include "mmc3.inc"

;void __fastcall__ mmc3_bank_switch_at(u8_t num)
.proc _mmc3_bank_switch_at 
    ldx mmc3_index 
    sta mmc3_bank, x
    sta MMC3_BANKSWITCH 
    rts 
.endproc