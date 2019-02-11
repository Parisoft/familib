    .include "joy.inc"
    
    .exportzp _joy2 

    .zeropage

_joy2:  .res .sizeof(joy_t)
