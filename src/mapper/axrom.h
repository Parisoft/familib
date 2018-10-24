#include "../def/def.h"

extern axrom_t axrom;
#pragma zpsym("axrom");

// switch to a PRG bank
// current bank is saved
// bank: 0 to 31
void __fastcall__ axrom_bank_switch(u8_t bank);

// switch to a PRG bank
// current bank is NOT saved
// bank: 0 to 31
void __fastcall__ axrom_bank_switch_stateless(u8_t bank);
