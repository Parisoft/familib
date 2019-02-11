    .include "axrom.inc"

    .exportzp _axrom 

    .segment "ZEROPAGE"

_axrom: .res .sizeof(axrom_t)
