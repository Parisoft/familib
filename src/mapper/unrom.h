#include "../def/def.h"

extern unrom_t unrom;
#pragma zpsym("unrom");

// switch to a PRG bank
// current bank is saved
// bank: 0 to 31
void __fastcall__ unrom_bank_switch(u8_t bank);

// switch to a PRG bank
// current bank is NOT saved
// bank: 0 to 31
void __fastcall__ unrom_bank_switch_stateless(u8_t bank);
