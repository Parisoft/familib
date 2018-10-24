    .exportzp _axrom 
    .export _axrom_banktable 

    .segment "RODATA"

_axrom_banktable:
    .byte $00, $01, $02, $03, $04, $05, $06, $07

    .segment "ZEROPAGE"

_axrom: .res 1
