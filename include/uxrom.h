#include "def.h"

#ifndef __FAMIUXROM__
#define __FAMIUXROM__
typedef struct {
    u8_t bank;
} uxrom_t;
#endif

extern uxrom_t uxrom;
#pragma zpsym("uxrom");

// switch to a PRG bank
// current bank is saved
// bank: 0 to 31
void __fastcall__ uxrom_bank_switch(u8_t bank);

// switch to a PRG bank
// current bank is NOT saved
// bank: 0 to 31
void __fastcall__ uxrom_bank_switch_nosave(u8_t bank);

// switch to a PRG bank w/o bus conflict
// current bank is saved
// bank: 0 to 31
void __fastcall__ uxrom_bank_switch_nobus(u8_t bank);

// switch to a PRG bank w/o bus conflict
// current bank is NOT saved
// bank: 0 to 31
void __fastcall__ uxrom_bank_switch_nobus_nosave(u8_t bank);
