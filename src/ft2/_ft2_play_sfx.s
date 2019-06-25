    .include "ft2.inc"

	.import popa

    .segment "CODE"

    ; void __fastcall__ ft2_play_sfx(u8 sound, u8 channel);
	.proc _ft2_play_sfx 
	.if(::FT_SFX_ENABLE)
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