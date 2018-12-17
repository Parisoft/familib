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

// functions for use in pragma wrapped-call
void __fastcall__ axrom_farcall_proc(void);
void __fastcall__ axrom_farcall_func(void);
void __fastcall__ axrom_farcall_cons(void);
void __fastcall__ axrom_farcall_supp(void);