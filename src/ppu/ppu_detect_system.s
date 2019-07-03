    .include "ppu.inc"

    .importzp _ppu 
    .export _ppu_detect_system 
    
    ; void ppu_detect_system();
    .proc _ppu_detect_system 
    bit PPUSTATUS 
@waitvblank:
    bit PPUSTATUS 
    bpl @waitvblank
    ldx #52
    ldy #24
@count:
    dex 
    bne @count
    dey 
    bne @count
    lda PPUSTATUS 
    and #$80
    sta ppu::system 
    rts 
    .endproc