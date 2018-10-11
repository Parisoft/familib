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
__MAPPER_INIT__ = mmc3_init 
    
    .include "reset.inc"
    .include "nes2header.inc"
    
    .segment "HEADER"

    nes2mapper  4
    nes2prg     08 * 16 * 1024 ; 128 KiB
    nes2chr     16 * 08 * 1024 ; 128 KiB
    nes2mirror  'V'
    nes2tv      'N', 'P'
    nes2end 
    