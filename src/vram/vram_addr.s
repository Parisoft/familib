    .include "vram.inc"
    .include "ppu.inc"

vram_addr = _vram_addr    

    ; void __fastcall__ vram_addr(u16_t addr);
    .proc _vram_addr 
    stx PPUADDR 
    sta PPUADDR 
    rts 
    .endproc