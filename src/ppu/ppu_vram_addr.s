    .export _ppu_vram_addr 

    .include "ppu.inc"

; void __fastcall__ ppu_vram_addr(u16_t addr);
.proc _ppu_vram_addr 
    stx PPUADDR 
    sta PPUADDR 
    rts 
.endproc