    .include "joy.inc"

    .exportzp _joy1 

    .zeropage

_joy1:  .res .sizeof(joy_t)
