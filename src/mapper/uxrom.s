    .include "uxrom.inc"
    
    .exportzp _uxrom 

    .segment "ZEROPAGE"

_uxrom: .res .sizeof(uxrom_t)
