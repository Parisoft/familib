    .include "zeropage.inc"
    
; PRG ROM bank mode:
; ------------------
; 0: $8000-$9FFF swappable
;    $C000-$DFFF fixed to second-last bank
;
; 1: $C000-$DFFF swappable,
;    $8000-$9FFF fixed to second-last bank)
MMC3_PRG_MODE = 1

; CHR ROM inversion:
; ------------------
; 0: 2 x 2 KiB banks at $0000-$0FFF,
;    4 x 1 KiB banks at $1000-$1FFF
;
; 1: 2 x 2 KiB banks at $1000-$1FFF 
;    4 x 1 KiB banks at $0000-$0FFF
MMC3_CHR_INVERSION = 1

    .importzp _mmc3 
    .proc mmc3_init 
    lda #((MMC3_PRG_MODE << 6) | (MMC3_CHR_INVERSION << 7))
    sta _mmc3 
    sta $8000
    rts 
    .endproc
____MAPPER_INIT__ = mmc3_init 
    
    .include "reset.inc"
    
    .segment "HEADER"

; iNES header
; see http://wiki.nesdev.com/w/index.php/INES

.byte $4e, $45, $53, $1a ; "NES" followed by MS-DOS EOF
.byte $08                ; size of PRG ROM in 16 KiB units
.byte $10                ; size of CHR ROM in 8 KiB units
.byte $01|$04            ; vertical mirroring | mapper 004 (MMC3)
.byte $00                ; mapper 004
.byte $00                ; size of PRG RAM in 8 KiB units
.res 7, $00              ; zero-filled
