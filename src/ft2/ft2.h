#include <stddef.h>
#include "../ppu/ppu.h"

#define ft2_init(data)                                  \
    __asm__("ldx #<(%v)", data);                        \
    __asm__("ldy #>(%v)", data);                        \
    __asm__("lda %v+%b", ppu, offsetof(ppu_t, system)); \
    __asm__("jsr _FamiToneInit");

#define ft2_init_ntsc(data)      \
    __asm__("ldx #<(%v)", data); \
    __asm__("ldy #>(%v)", data); \
    __asm__("lda #1");           \
    __asm__("jsr _FamiToneInit");

#define ft2_init_palm(data)      \
    __asm__("ldx #<(%v)", data); \
    __asm__("ldy #>(%v)", data); \
    __asm__("lda #0");           \
    __asm__("jsr _FamiToneInit");

// play a music in FamiTone format
extern void __fastcall__ ft2_play_music(u8 song);

// stop music
extern void __fastcall__ ft2_stop_music(void);

// pause and unpause music
extern void __fastcall__ ft2_pause_music(u8 pause);

// play FamiTone sound effect on channel 0..3
extern void __fastcall__ ft2_play_sfx(u8 sound, u8 channel);

// play a DPCM sample, 1..63
extern void __fastcall__ ft2_play_sample(u8 sample);

// update the sound engine
// must be called each frame
extern void __fastcall__ ft2_update(void);