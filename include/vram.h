#include "def.h"

// set the vram address
void __fastcall__ vram_addr(u16_t addr);

// copy 4kiB of data from src to vram
void __fastcall__ vram_cpy4k(u8_t* src);

// copy 2kiB of data from src to vram
void __fastcall__ vram_cpy2k(u8_t* src);

// copy 1kiB of data from src to vram
void __fastcall__ vram_cpy1k(u8_t* src);