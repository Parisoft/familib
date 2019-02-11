    .define MMC3_BANKSELECT $8000
    .define MMC3_BANKSWITCH $8001
    .define MMC3_IRQLATCH $C000
    .define MMC3_IRQRELOAD $C001
    .define MMC3_IRQDISABLE $E000
    .define MMC3_IRQENABLE $E001

    .struct mmc3_t
    mode    .res 1
    slot    .res 1
    bank    .res 8
    .endstruct

    .define mmc3_mode _mmc3+mmc3_t::mode 
    .define mmc3_slot _mmc3+mmc3_t::slot
    .define mmc3_bank _mmc3+mmc3_t::bank 