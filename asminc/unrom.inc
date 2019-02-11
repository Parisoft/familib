    .include "zeropage.inc"
    .include "reset.inc"
    .include "nes2header.inc"
    
    .segment "HEADER"

    nes2mapper  2
    nes2prg     8 * 16 * 1024 ; 128 KiB
    nes2chr     0 * 08 * 1024
    nes2chrram  1 * 08 * 1024 ; 8 KiB
    nes2mirror  'V'
    nes2tv      'N', 'P'
    nes2end 