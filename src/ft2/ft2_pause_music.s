    .include "ft2.inc"

    .segment "CODE"

; void __fastcall__ ft2_pause_music(u8_t pause);
_ft2_pause_music = FamiToneMusicPause 

ft2_pause_music = FamiToneMusicPause

;------------------------------------------------------------------------------
; pause and unpause current music
; in: A 0 or not 0 to play or pause
;------------------------------------------------------------------------------

FamiToneMusicPause:

	tax					;set SZ flags for A
	beq @unpause
	
@pause:

	jsr FamiToneSampleStop
	
	lda #0				;mute sound
	sta FT_CH1_VOLUME
	sta FT_CH2_VOLUME
	sta FT_CH3_VOLUME
	sta FT_CH4_VOLUME
	lda FT_SONG_SPEED	;set pause flag
	ora #$80
	bne @done
@unpause:
	lda FT_SONG_SPEED	;reset pause flag
	and #$7f
@done:
	sta FT_SONG_SPEED

	rts
