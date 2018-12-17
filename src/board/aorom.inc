    .include "zeropage.inc"
    .include "reset.inc"
    .include "nes2header.inc"
    
    .segment "HEADER"

    nes2mapper  7
    nes2prg     8 * 32 * 1024
    nes2chr     0 * 08 * 1024
    nes2chrram  8 * 1024
    nes2mirror  '4'
    nes2tv      'N', 'P'
    nes2end 