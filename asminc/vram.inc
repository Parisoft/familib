    .importzp ptr1
    .global vram_addr;(u16_t addr);
    .global vram_cpy4k;(u8_t* src);
    .global vram_cpy2k;(u8_t* src);
    .global vram_cpy1k;(u8_t* src);
    ; For C code
    .global _vram_addr
    .global _vram_cpy4k
    .global _vram_cpy2k
    .global _vram_cpy1k