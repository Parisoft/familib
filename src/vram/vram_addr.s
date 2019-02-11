    .export _vram_addr 

PPUADDR   = $2006

    ; void __fastcall__ vram_addr(u16_t addr);
    .proc _vram_addr 
    stx PPUADDR 
    sta PPUADDR 
    rts 
    .endproc