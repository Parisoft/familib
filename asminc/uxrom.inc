    .struct uxrom_t
    bank    .res 1
    .endstruct

    .define uxrom_bank  _uxrom+uxrom_t::bank