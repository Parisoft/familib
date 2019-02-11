    .include "mmc3.inc"
    
    .exportzp _mmc3 

    .segment "ZEROPAGE"
    
_mmc3:  .res .sizeof(mmc3_t)