#include "cpu/cpu.h"
#include "def/def.h"
#include "ft2/ft2.h"
#include "joy/joy.h"
#include "mapper/axrom.h"
#include "mapper/mmc3.h"
#include "mapper/uxrom.h"
#include "oam/oam.h"
#include "ppu/ppu.h"

//-----------------
// Segment pragmas
//-----------------
// clang-format off
#define strlit(f) #f
#define push_rodata(prg) strlit(rodata-name(push, prg))
#define push_code(prg) strlit(code-name(push, prg))
#define push_zp "bss-name(push, \"ZEROPAGE\")"
#define push_farcall(tramp, bank) strlit(wrapped-call(push, tramp, bank))
#define pop_code "code-name(pop)"
#define pop_rodata "rodata-name(pop)"
#define pop_zp "bss-name(pop)"
#define pop_farcall "wrapped-call(pop)"
// clang-format on
//-----------------
