#include "def.h"

#ifndef __FAMIAXROM__
#define __FAMIAXROM__
typedef struct {
    u8_t bank;
} axrom_t;
#endif

extern axrom_t axrom;
#pragma zpsym("axrom");

// switch to a PRG bank
// current bank is saved
// bank: 0 to 31
void __fastcall__ axrom_bank_switch(u8_t bank);

// switch to a PRG bank
// current bank is NOT saved
// bank: 0 to 31
void __fastcall__ axrom_bank_switch_nosave(u8_t bank);

// switch to a PRG bank w/o bus conflict
// current bank is saved
// bank: 0 to 31
void __fastcall__ axrom_bank_switch_nobus(u8_t bank);

// switch to a PRG bank w/o bus conflict
// current bank is NOT saved
// bank: 0 to 31
void __fastcall__ axrom_bank_switch_nobus_nosave(u8_t bank);

// functions for use in pragma wrapped-call
void __fastcall__ axrom_farcall_proc(void);
void __fastcall__ axrom_farcall_func(void);
void __fastcall__ axrom_farcall_cons(void);
void __fastcall__ axrom_farcall_supp(void);
void __fastcall__ axrom_farcall_proc_nobus(void);
void __fastcall__ axrom_farcall_func_nobus(void);
void __fastcall__ axrom_farcall_cons_nobus(void);
void __fastcall__ axrom_farcall_supp_nobus(void);