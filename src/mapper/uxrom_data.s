    .export _uxrom_banktable 

    .segment "RODATA"

_uxrom_banktable:
    .byte $00, $01, $02, $03, $04, $05, $06 ; uxrom
    .byte $07, $08, $09, $0A, $0B, $0C, $0D, $0E ; uorom
    ; .byte $0F, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F ; unrom-512
