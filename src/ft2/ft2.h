#include "../def/def.h"

// prepare a sound file fot further play
// the system region is autodetected (ppu_detect_region() must be called prior this function)
void __fastcall__ ft2_init(const u8_t *data);

// prepare a sound file fot further play
// the system region is NTSC
void __fastcall__ ft2_init_ntsc(const u8_t *data);

// prepare a sound file fot further play
// the system region is PAL-M
void __fastcall__ ft2_init_palm(const u8_t *data);

// prepare a sfx file for further play
void __fastcall__ ft2_init_sfx(const u8_t *data);

// play a music in FamiTone format
void __fastcall__ ft2_play_music(u8_t song);

// stop music
void __fastcall__ ft2_stop_music(void);

// pause and unpause music
void __fastcall__ ft2_pause_music(u8_t pause);

// play FamiTone sound effect on channel 0..3
void __fastcall__ ft2_play_sfx(u8_t sound, u8_t channel);

// play a DPCM sample, 1..63
void __fastcall__ ft2_play_sample(u8_t sample);

// update the sound engine
// must be called each frame
void __fastcall__ ft2_update(void);