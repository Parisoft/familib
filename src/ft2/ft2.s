	.importzp _ppu 
	.import popa 
	.export _ft2_init, _ft2_init_ntsc, _ft2_init_palm, _ft2_init_sfx, _ft2_play_music, _ft2_stop_music, _ft2_pause_music, _ft2_play_sfx, _ft2_play_sample, _ft2_update 

	.segment "ZEROPAGE"

ft2temp:		.res 3

	.segment "BSS"
	.align $100, 0

FT_TEMP			= ft2temp	;3 bytes in zeropage used by the library as a scratchpad
FT_BASE_ADR		= *			;page in the RAM used for FT2 variables, should be $xx00
FT_DPCM_OFF		= $C000	    ;$c000..$ffc0, 64-byte steps
FT_SFX_STREAMS	= 4		    ;number of sound effects played at once, 1..4
.define FT_DPCM_ENABLE	1	;undefine to exclude all DMC code
.define FT_SFX_ENABLE	1	;undefine to exclude all sound effects code
.define FT_THREAD		1	;undefine if you are calling sound effects from the same thread as the sound update call
.define FT_PAL_SUPPORT	1	;undefine to exclude PAL support
.define FT_NTSC_SUPPORT	1	;undefine to exclude NTSC support


	.segment "CODE"
	
	.include "famitone2.inc"

	.segment "BSS" 

ft2vars:		.res FT_BASE_SIZE 
	
	.segment "CODE" 

region = _ppu+4 

; void __fastcall__ ft2_init(const u8 *data);
.proc _ft2_init 
	pha 
	txa 
	tay		; Y = >data
	pla 
	tax 	; X = <data
	lda region 
	jmp FamiToneInit 
.endproc

; void __fastcall__ ft2_init_ntsc(const u8 *data);
.proc _ft2_init_ntsc 
	pha 
	txa 
	tay		; Y = >data
	pla 
	tax 	; X = <data
	lda #1 
	jmp FamiToneInit 
.endproc

; void __fastcall__ ft2_init_palm(const u8 *data);
.proc _ft2_init_palm 
	pha 
	txa 
	tay		; Y = >data
	pla 
	tax 	; X = <data
	lda #0 
	jmp FamiToneInit 
.endproc

; void __fastcall__ ft2_init_sfx(const u8 *data);
.proc _ft2_init_sfx 
	pha 
	txa 
	tay		; Y = >data
	pla 
	tax 	; X = <data
	jmp FamiToneSfxInit 
.endproc

; void __fastcall__ ft2_play_music(u8 song);
_ft2_play_music=FamiToneMusicPlay 

; void __fastcall__ ft2_stop_music(void);
_ft2_stop_music=FamiToneMusicStop 

; void __fastcall__ ft2_pause_music(u8 pause);
_ft2_pause_music=FamiToneMusicPause 

; void __fastcall__ ft2_play_sfx(u8 sound, u8 channel);
.proc _ft2_play_sfx 
.if(FT_SFX_ENABLE)
	and #$03
	tax 
	lda @sfxPriority, x 
	tax 
	jsr popa 
	jmp FamiToneSfxPlay 
@sfxPriority:
	.byte FT_SFX_CH0,FT_SFX_CH1,FT_SFX_CH2,FT_SFX_CH3
.else
	rts 
.endif
.endproc

; void __fastcall__ ft2_play_sample(u8 sample);
.if(FT_DPCM_ENABLE)
_ft2_play_sample=FamiToneSamplePlay 
.else
.proc _ft2_play_sample 
	rts 
.endproc
.endif

; void __fastcall__ ft2_update(void);
_ft2_update=FamiToneUpdate 
