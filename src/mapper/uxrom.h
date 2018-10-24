#include "../def/def.h"

extern uxrom_t uxrom;
#pragma zpsym("uxrom");

// switch to a PRG bank
// current bank is saved
// bank: 0 to 31
void __fastcall__ uxrom_bank_switch(u8_t bank);

// switch to a PRG bank
// current bank is NOT saved
// bank: 0 to 31
void __fastcall__ uxrom_bank_switch_stateless(u8_t bank);
