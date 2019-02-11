    .export _axrom_banktable 

    .segment "RODATA"

_axrom_banktable:
    .byte $00, $01, $02, $03, $04, $05, $06, $07 ; vram 0 - prg 0 to 7  (std)
    .byte $08, $09, $0A, $0B, $0C, $0D, $0E, $0F ; vram 0 - prg 8 to 15 (oversized)
    .byte $10, $11, $12, $13, $14, $15, $16, $17 ; vram 1 - prg 0 to 7  (std)
    .byte $10, $11, $12, $13, $14, $15, $16, $17 ; vram 1 - prg 8 to 15 (oversized)
