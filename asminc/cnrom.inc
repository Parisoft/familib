    .include "zeropage.inc"
    .include "reset.inc"
    .include "nes2header.inc"
    
    .segment "HEADER"

    nes2mapper  3
    nes2prg     2 * 16 * 1024   ; 32KiB
    nes2chr     4 * 08 * 1024   ; 32KiB
    nes2mirror  'V'
    nes2tv      'N', 'P'
    nes2end 