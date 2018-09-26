#include "../def/def.h"

#define MMC3_BANKSELECT 0x8000
#define MMC3_BANKSWITCH 0x8001
#define MMC3_IRQLATCH 0xC000
#define MMC3_IRQRELOAD 0xC001
#define MMC3_IRQDISABLE 0xE000
#define MMC3_IRQENABLE 0xE001

extern mmc3_t mmc3;
#pragma zpsym("mmc3");

// Select the bank at mmc3.index
#define mmc3_bank_select()     \
    __asm__("lda %v+0", mmc3); \
    __asm__("ora %v+1", mmc3); \
    __asm__("sta %w", MMC3_BANKSELECT);

// Switch to bank at mmc3.bank based on last selection
#define mmc3_bank_switch()        \
    __asm__("ldx %v+1", mmc3);    \
    __asm__("lda %v+2, x", mmc3); \
    __asm__("sta %w", MMC3_BANKSWITCH);

// Switch all 2 x 2 KiB CHR banks at mmc3.bank[0~1]
#define mmc3_bank_switch_chr2k()        \
    __asm__("ldx %v+0", mmc3);          \
    __asm__("stx %w", MMC3_BANKSELECT); \
    __asm__("lda %v+2+0", mmc3);        \
    __asm__("sta %w", MMC3_BANKSWITCH); \
    __asm__("inx");                     \
    __asm__("stx %w", MMC3_BANKSELECT); \
    __asm__("lda %v+2+1", mmc3);        \
    __asm__("sta %w", MMC3_BANKSWITCH);

// Switch all 4 x 1 KiB CHR banks at mmc3.bank[2~5]
#define mmc3_bank_switch_chr1k()        \
    __asm__("ldx %v+0", mmc3);          \
    __asm__("inx");                     \
    __asm__("inx");                     \
    __asm__("stx %w", MMC3_BANKSELECT); \
    __asm__("lda %v+2+2", mmc3);        \
    __asm__("sta %w", MMC3_BANKSWITCH); \
    __asm__("inx");                     \
    __asm__("stx %w", MMC3_BANKSELECT); \
    __asm__("lda %v+2+3", mmc3);        \
    __asm__("sta %w", MMC3_BANKSWITCH); \
    __asm__("inx");                     \
    __asm__("stx %w", MMC3_BANKSELECT); \
    __asm__("lda %v+2+4", mmc3);        \
    __asm__("sta %w", MMC3_BANKSWITCH); \
    __asm__("inx");                     \
    __asm__("stx %w", MMC3_BANKSELECT); \
    __asm__("lda %v+2+5", mmc3);        \
    __asm__("sta %w", MMC3_BANKSWITCH);

#define mmc3_irq_ack() \
    __asm__("lda #1"); \
    __asm__("sta %w", MMC3_IRQDISABLE);

// Specify which bank register to update on next write to Bank Data register
// 0: Select 2 KB CHR bank at PPU $0000-$07FF (or $1000-$17FF);
// 1: Select 2 KB CHR bank at PPU $0800-$0FFF (or $1800-$1FFF);
// 2: Select 1 KB CHR bank at PPU $1000-$13FF (or $0000-$03FF);
// 3: Select 1 KB CHR bank at PPU $1400-$17FF (or $0400-$07FF);
// 4: Select 1 KB CHR bank at PPU $1800-$1BFF (or $0800-$0BFF);
// 5: Select 1 KB CHR bank at PPU $1C00-$1FFF (or $0C00-$0FFF);
// 6: Select 8 KB PRG ROM bank at $8000-$9FFF (or $C000-$DFFF);
// 7: Select 8 KB PRG ROM bank at $A000-$BFFF
void __fastcall__ mmc3_bank_select_at(u8_t idx);

// Switch to a bank based on last selection
// num is a bank number starting at 0
void __fastcall__ mmc3_bank_switch_at(u8_t num);

// Request an interruption at a given scanline
void __fastcall__ mmc3_irq_set(u8_t scanline);
