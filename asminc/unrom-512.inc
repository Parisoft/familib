    .include "zeropage.inc"
    .include "reset.inc"
    .include "nes2header.inc"
    
    .segment "HEADER"

    nes2mapper  30
    nes2prg     32 * 16 * 1024 ; 512 KiB
    nes2chr     00 * 08 * 1024
    nes2chrram  04 * 08 * 1024 ; 32 KiB
    nes2mirror  'V'
    nes2tv      'N', 'P'
    nes2end 