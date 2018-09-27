    .importzp _mmc3 
    .export _mmc3_irq_set 
    .include "mmc3.inc"

;void __fastcall__ mmc3_irq_set(u8_t scanline)
.proc _mmc3_irq_set 
   sta MMC3_IRQDISABLE 
   sta MMC3_IRQLATCH 
   sta MMC3_IRQRELOAD 
   sta MMC3_IRQENABLE 
   rts 
.endproc