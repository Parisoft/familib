#include "../def/def.h"

// set the vram address
void __fastcall__ vram_addr(u16_t addr);

// copy 4kiB of data from src to vram
void __fastcall__ vram_cp4k(u8_t* src);

// copy 1kiB of data from src to vram
void __fastcall__ vram_cp1k(u8_t* src);