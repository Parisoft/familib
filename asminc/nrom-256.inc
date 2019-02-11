    .include "zeropage.inc"
    .include "reset.inc"
    .include "nes2header.inc"
    
    .segment "HEADER"

    nes2mapper  0
    nes2prg     2 * 16 * 1024
    nes2chr     1 * 08 * 1024
    nes2mirror  'V'
    nes2tv      'N', 'P'
    nes2end 