    .include "ft2.inc"

    .segment "CODE"

ft_init = FamiToneInit
ft2_stop_music = FamiToneMusicStop
_ft2_stop_music = FamiToneMusicStop

;------------------------------------------------------------------------------
; reset APU, initialize FamiTone
; in: A   0 for PAL, not 0 for NTSC
;     X,Y pointer to music data
;------------------------------------------------------------------------------

FamiToneInit:

	stx FT_SONG_LIST_L		;store music data pointer for further use
	sty FT_SONG_LIST_H
	stx <FT_TEMP_PTR_L
	sty <FT_TEMP_PTR_H

	.if(FT_PITCH_FIX)
	tax						;set SZ flags for A
	beq @pal
	lda #64
@pal:
	.else
	.if(FT_PAL_SUPPORT)
	lda #0
	.endif
	.if(FT_NTSC_SUPPORT)
	lda #64
	.endif
	.endif
	sta FT_PAL_ADJUST

	jsr FamiToneMusicStop	;initialize channels and envelopes

	ldy #1
	lda (FT_TEMP_PTR),y		;get instrument list address
	sta FT_INSTRUMENT_L
	iny
	lda (FT_TEMP_PTR),y
	sta FT_INSTRUMENT_H
	iny
	lda (FT_TEMP_PTR),y		;get sample list address
	sta FT_DPCM_LIST_L
	iny
	lda (FT_TEMP_PTR),y
	sta FT_DPCM_LIST_H

	lda #$ff				;previous pulse period MSB, to not write it when not changed
	sta FT_PULSE1_PREV
	sta FT_PULSE2_PREV

	lda #$0f				;enable channels, stop DMC
	sta APU_SND_CHN
	lda #$80				;disable triangle length counter
	sta APU_TRI_LINEAR
	lda #$00				;load noise length
	sta APU_NOISE_HI

	lda #$30				;volumes to 0
	sta APU_PL1_VOL
	sta APU_PL2_VOL
	sta APU_NOISE_VOL
	lda #$08				;no sweep
	sta APU_PL1_SWEEP
	sta APU_PL2_SWEEP

	;jmp FamiToneMusicStop


;------------------------------------------------------------------------------
; stop music that is currently playing, if any
; in: none
;------------------------------------------------------------------------------

FamiToneMusicStop:

	lda #0
	sta FT_SONG_SPEED		;stop music, reset pause flag
	sta FT_DPCM_EFFECT		;no DPCM effect playing

	ldx #.lobyte(FT_CHANNELS)	;initialize channel structures

@set_channels:

	lda #0
	sta FT_CHN_REPEAT,x
	sta FT_CHN_INSTRUMENT,x
	sta FT_CHN_NOTE,x
	sta FT_CHN_REF_LEN,x
	lda #$30
	sta FT_CHN_DUTY,x

	inx						;next channel
	cpx #.lobyte(FT_CHANNELS)+FT_CHANNELS_ALL
	bne @set_channels

	ldx #.lobyte(FT_ENVELOPES)	;initialize all envelopes to the dummy envelope

@set_envelopes:

	lda #.lobyte (_FT2DummyEnvelope)
	sta FT_ENV_ADR_L,x
	lda #.hibyte(_FT2DummyEnvelope)
	sta FT_ENV_ADR_H,x
	lda #0
	sta FT_ENV_REPEAT,x
	sta FT_ENV_VALUE,x
	inx
	cpx #.lobyte(FT_ENVELOPES)+FT_ENVELOPES_ALL

	bne @set_envelopes

	jmp FamiToneSampleStop

;dummy envelope used to initialize all channels with silence

_FT2DummyEnvelope:
	.byte $c0,$00,$00