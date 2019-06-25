    .include "ft2.inc"

    .segment "CODE"

ft2_update = FamiToneUpdate
_ft2_update = FamiToneUpdate

;------------------------------------------------------------------------------
; update FamiTone state, should be called every NMI
; in: none
;------------------------------------------------------------------------------

FamiToneUpdate:

	.if(FT_THREAD)
	lda FT_TEMP_PTR_L
	pha
	lda FT_TEMP_PTR_H
	pha
	.endif

	lda FT_SONG_SPEED		;speed 0 means that no music is playing currently
	bmi @pause				;bit 7 set is the pause flag
	bne @update
@pause:
	jmp @update_sound

@update:

	clc						;update frame counter that considers speed, tempo, and PAL/NTSC
	lda FT_TEMPO_ACC_L
	adc FT_TEMPO_STEP_L
	sta FT_TEMPO_ACC_L
	lda FT_TEMPO_ACC_H
	adc FT_TEMPO_STEP_H
	cmp FT_SONG_SPEED
	bcs @update_row			;overflow, row update is needed
	sta FT_TEMPO_ACC_H		;no row update, skip to the envelopes update
	jmp @update_envelopes

@update_row:

	sec
	sbc FT_SONG_SPEED
	sta FT_TEMPO_ACC_H


	ldx #.lobyte(FT_CH1_VARS)	;process channel 1
	jsr _FT2ChannelUpdate
	bcc @no_new_note1
	ldx #.lobyte(FT_CH1_ENVS)
	lda FT_CH1_INSTRUMENT
	jsr _FT2SetInstrument
	sta FT_CH1_DUTY
@no_new_note1:

	ldx #.lobyte(FT_CH2_VARS)	;process channel 2
	jsr _FT2ChannelUpdate
	bcc @no_new_note2
	ldx #.lobyte(FT_CH2_ENVS)
	lda FT_CH2_INSTRUMENT
	jsr _FT2SetInstrument
	sta FT_CH2_DUTY
@no_new_note2:

	ldx #.lobyte(FT_CH3_VARS)	;process channel 3
	jsr _FT2ChannelUpdate
	bcc @no_new_note3
	ldx #.lobyte(FT_CH3_ENVS)
	lda FT_CH3_INSTRUMENT
	jsr _FT2SetInstrument
@no_new_note3:

	ldx #.lobyte(FT_CH4_VARS)	;process channel 4
	jsr _FT2ChannelUpdate
	bcc @no_new_note4
	ldx #.lobyte(FT_CH4_ENVS)
	lda FT_CH4_INSTRUMENT
	jsr _FT2SetInstrument
	sta FT_CH4_DUTY
@no_new_note4:

	.if(FT_DPCM_ENABLE)

	ldx #.lobyte(FT_CH5_VARS)	;process channel 5
	jsr _FT2ChannelUpdate
	bcc @no_new_note5
	lda FT_CH5_NOTE
	bne @play_sample
	jsr FamiToneSampleStop
	bne @no_new_note5		;A is non-zero after FamiToneSampleStop
@play_sample:
	jsr FamiToneSamplePlayM
@no_new_note5:

	.endif


@update_envelopes:

	ldx #.lobyte(FT_ENVELOPES)	;process 11 envelopes

@env_process:

	lda FT_ENV_REPEAT,x		;check envelope repeat counter
	beq @env_read			;if it is zero, process envelope
	dec FT_ENV_REPEAT,x		;otherwise decrement the counter
	bne @env_next

@env_read:

	lda FT_ENV_ADR_L,x		;load envelope data address into temp
	sta <FT_TEMP_PTR_L
	lda FT_ENV_ADR_H,x
	sta <FT_TEMP_PTR_H
	ldy FT_ENV_PTR,x		;load envelope pointer

@env_read_value:

	lda (FT_TEMP_PTR),y		;read a byte of the envelope data
	bpl @env_special		;values below 128 used as a special code, loop or repeat
	clc						;values above 128 are output value+192 (output values are signed -63..64)
	adc #256-192
	sta FT_ENV_VALUE,x		;store the output value
	iny						;advance the pointer
	bne @env_next_store_ptr ;bra

@env_special:

	bne @env_set_repeat		;zero is the loop point, non-zero values used for the repeat counter
	iny						;advance the pointer
	lda (FT_TEMP_PTR),y		;read loop position
	tay						;use loop position
	jmp @env_read_value		;read next byte of the envelope

@env_set_repeat:

	iny
	sta FT_ENV_REPEAT,x		;store the repeat counter value

@env_next_store_ptr:

	tya						;store the envelope pointer
	sta FT_ENV_PTR,x

@env_next:

	inx						;next envelope

	cpx #.lobyte(FT_ENVELOPES)+FT_ENVELOPES_ALL
	bne @env_process


@update_sound:

	;convert envelope and channel output data into APU register values in the output buffer

	lda FT_CH1_NOTE
	beq @ch1cut
	clc
	adc FT_CH1_NOTE_OFF
	.if(FT_PITCH_FIX)
	ora FT_PAL_ADJUST
	.endif
	tax
	lda FT_CH1_PITCH_OFF
	tay
	adc _FT2NoteTableLSB,x
	sta FT_MR_PULSE1_L
	tya						;sign extension for the pitch offset
	ora #$7f
	bmi @ch1sign
	lda #0
@ch1sign:
	adc _FT2NoteTableMSB,x

	.if(!FT_SFX_ENABLE)
	cmp FT_PULSE1_PREV
	beq @ch1prev
	sta FT_PULSE1_PREV
	.endif

	sta FT_MR_PULSE1_H
@ch1prev:
	lda FT_CH1_VOLUME
@ch1cut:
	ora FT_CH1_DUTY
	sta FT_MR_PULSE1_V


	lda FT_CH2_NOTE
	beq @ch2cut
	clc
	adc FT_CH2_NOTE_OFF
	.if(FT_PITCH_FIX)
	ora FT_PAL_ADJUST
	.endif
	tax
	lda FT_CH2_PITCH_OFF
	tay
	adc _FT2NoteTableLSB,x
	sta FT_MR_PULSE2_L
	tya
	ora #$7f
	bmi @ch2sign
	lda #0
@ch2sign:
	adc _FT2NoteTableMSB,x

	.if(!FT_SFX_ENABLE)
	cmp FT_PULSE2_PREV
	beq @ch2prev
	sta FT_PULSE2_PREV
	.endif

	sta FT_MR_PULSE2_H
@ch2prev:
	lda FT_CH2_VOLUME
@ch2cut:
	ora FT_CH2_DUTY
	sta FT_MR_PULSE2_V


	lda FT_CH3_NOTE
	beq @ch3cut
	clc
	adc FT_CH3_NOTE_OFF
	.if(FT_PITCH_FIX)
	ora FT_PAL_ADJUST
	.endif
	tax
	lda FT_CH3_PITCH_OFF
	tay
	adc _FT2NoteTableLSB,x
	sta FT_MR_TRI_L
	tya
	ora #$7f
	bmi @ch3sign
	lda #0
@ch3sign:
	adc _FT2NoteTableMSB,x
	sta FT_MR_TRI_H
	lda FT_CH3_VOLUME
@ch3cut:
	ora #$80
	sta FT_MR_TRI_V


	lda FT_CH4_NOTE
	beq @ch4cut
	clc
	adc FT_CH4_NOTE_OFF
	and #$0f
	eor #$0f
	sta <FT_TEMP_VAR1
	lda FT_CH4_DUTY
	asl a
	and #$80
	ora <FT_TEMP_VAR1
	sta FT_MR_NOISE_F
	lda FT_CH4_VOLUME
@ch4cut:
	ora #$f0
	sta FT_MR_NOISE_V


	.if(FT_SFX_ENABLE)

	;process all sound effect streams

	.if FT_SFX_STREAMS>0
	ldx #FT_SFX_CH0
	jsr _FT2SfxUpdate
	.endif
	.if FT_SFX_STREAMS>1
	ldx #FT_SFX_CH1
	jsr _FT2SfxUpdate
	.endif
	.if FT_SFX_STREAMS>2
	ldx #FT_SFX_CH2
	jsr _FT2SfxUpdate
	.endif
	.if FT_SFX_STREAMS>3
	ldx #FT_SFX_CH3
	jsr _FT2SfxUpdate
	.endif


	;send data from the output buffer to the APU

	lda FT_OUT_BUF		;pulse 1 volume
	sta APU_PL1_VOL
	lda FT_OUT_BUF+1	;pulse 1 period LSB
	sta APU_PL1_LO
	lda FT_OUT_BUF+2	;pulse 1 period MSB, only applied when changed
	cmp FT_PULSE1_PREV
	beq @no_pulse1_upd
	sta FT_PULSE1_PREV
	sta APU_PL1_HI
@no_pulse1_upd:

	lda FT_OUT_BUF+3	;pulse 2 volume
	sta APU_PL2_VOL
	lda FT_OUT_BUF+4	;pulse 2 period LSB
	sta APU_PL2_LO
	lda FT_OUT_BUF+5	;pulse 2 period MSB, only applied when changed
	cmp FT_PULSE2_PREV
	beq @no_pulse2_upd
	sta FT_PULSE2_PREV
	sta APU_PL2_HI
@no_pulse2_upd:

	lda FT_OUT_BUF+6	;triangle volume (plays or not)
	sta APU_TRI_LINEAR
	lda FT_OUT_BUF+7	;triangle period LSB
	sta APU_TRI_LO
	lda FT_OUT_BUF+8	;triangle period MSB
	sta APU_TRI_HI

	lda FT_OUT_BUF+9	;noise volume
	sta APU_NOISE_VOL
	lda FT_OUT_BUF+10	;noise period
	sta APU_NOISE_LO

	.endif

	.if(FT_THREAD)
	pla
	sta FT_TEMP_PTR_H
	pla
	sta FT_TEMP_PTR_L
	.endif

	rts

;internal routine, sets up envelopes of a channel according to current instrument
;in X envelope group offset, A instrument number

_FT2SetInstrument:
	asl a					;instrument number is pre multiplied by 4
	tay
	lda FT_INSTRUMENT_H
	adc #0					;use carry to extend range for 64 instruments
	sta <FT_TEMP_PTR_H
	lda FT_INSTRUMENT_L
	sta <FT_TEMP_PTR_L

	lda (FT_TEMP_PTR),y		;duty cycle
	sta <FT_TEMP_VAR1
	iny

	lda (FT_TEMP_PTR),y		;instrument pointer LSB
	sta FT_ENV_ADR_L,x
	iny
	lda (FT_TEMP_PTR),y		;instrument pointer MSB
	iny
	sta FT_ENV_ADR_H,x
	inx						;next envelope

	lda (FT_TEMP_PTR),y		;instrument pointer LSB
	sta FT_ENV_ADR_L,x
	iny
	lda (FT_TEMP_PTR),y		;instrument pointer MSB
	sta FT_ENV_ADR_H,x

	lda #0
	sta FT_ENV_REPEAT-1,x	;reset env1 repeat counter
	sta FT_ENV_PTR-1,x		;reset env1 pointer
	sta FT_ENV_REPEAT,x		;reset env2 repeat counter
	sta FT_ENV_PTR,x		;reset env2 pointer

	cpx #.lobyte(FT_CH4_ENVS)	;noise channel has only two envelopes
	bcs @no_pitch

	inx						;next envelope
	iny
	sta FT_ENV_REPEAT,x		;reset env3 repeat counter
	sta FT_ENV_PTR,x		;reset env3 pointer
	lda (FT_TEMP_PTR),y		;instrument pointer LSB
	sta FT_ENV_ADR_L,x
	iny
	lda (FT_TEMP_PTR),y		;instrument pointer MSB
	sta FT_ENV_ADR_H,x

@no_pitch:
	lda <FT_TEMP_VAR1
	rts

;internal routine, parses channel note data

_FT2ChannelUpdate:

	lda FT_CHN_REPEAT,x		;check repeat counter
	beq @no_repeat
	dec FT_CHN_REPEAT,x		;decrease repeat counter
	clc						;no new note
	rts

@no_repeat:
	lda FT_CHN_PTR_L,x		;load channel pointer into temp
	sta <FT_TEMP_PTR_L
	lda FT_CHN_PTR_H,x
	sta <FT_TEMP_PTR_H
@no_repeat_r:
	ldy #0

@read_byte:
	lda (FT_TEMP_PTR),y		;read byte of the channel

	inc <FT_TEMP_PTR_L		;advance pointer
	bne @no_inc_ptr1
	inc <FT_TEMP_PTR_H
@no_inc_ptr1:

	ora #0
	bmi @special_code		;bit 7 0=note 1=special code

	lsr a					;bit 0 set means the note is followed by an empty row
	bcc @no_empty_row
	inc FT_CHN_REPEAT,x		;set repeat counter to 1
@no_empty_row:
	sta FT_CHN_NOTE,x		;store note code
	sec						;new note flag is set
	bcs @done ;bra

@special_code:
	and #$7f
	lsr a
	bcs @set_empty_rows
	asl a
	asl a
	sta FT_CHN_INSTRUMENT,x	;store instrument number*4
	bcc @read_byte ;bra

@set_empty_rows:
	cmp #$3d
	bcc @set_repeat
	beq @set_speed
	cmp #$3e
	beq @set_loop

@set_reference:
	clc						;remember return address+3
	lda <FT_TEMP_PTR_L
	adc #3
	sta FT_CHN_RETURN_L,x
	lda <FT_TEMP_PTR_H
	adc #0
	sta FT_CHN_RETURN_H,x
	lda (FT_TEMP_PTR),y		;read length of the reference (how many rows)
	sta FT_CHN_REF_LEN,x
	iny
	lda (FT_TEMP_PTR),y		;read 16-bit absolute address of the reference
	sta <FT_TEMP_VAR1		;remember in temp
	iny
	lda (FT_TEMP_PTR),y
	sta <FT_TEMP_PTR_H
	lda <FT_TEMP_VAR1
	sta <FT_TEMP_PTR_L
	ldy #0
	jmp @read_byte

@set_speed:
	lda (FT_TEMP_PTR),y
	sta FT_SONG_SPEED
	inc <FT_TEMP_PTR_L		;advance pointer after reading the speed value
	bne @read_byte
	inc <FT_TEMP_PTR_H
	bne @read_byte ;bra

@set_loop:
	lda (FT_TEMP_PTR),y
	sta <FT_TEMP_VAR1
	iny
	lda (FT_TEMP_PTR),y
	sta <FT_TEMP_PTR_H
	lda <FT_TEMP_VAR1
	sta <FT_TEMP_PTR_L
	dey
	jmp @read_byte

@set_repeat:
	sta FT_CHN_REPEAT,x		;set up repeat counter, carry is clear, no new note

@done:
	lda FT_CHN_REF_LEN,x	;check reference row counter
	beq @no_ref				;if it is zero, there is no reference
	dec FT_CHN_REF_LEN,x	;decrease row counter
	bne @no_ref

	lda FT_CHN_RETURN_L,x	;end of a reference, return to previous pointer
	sta FT_CHN_PTR_L,x
	lda FT_CHN_RETURN_H,x
	sta FT_CHN_PTR_H,x
	rts

@no_ref:
	lda <FT_TEMP_PTR_L
	sta FT_CHN_PTR_L,x
	lda <FT_TEMP_PTR_H
	sta FT_CHN_PTR_H,x
	rts

;internal routine, update one sound effect stream
;in: X is offset of sound effect stream
    .if(FT_SFX_ENABLE)
_FT2SfxUpdate:

	lda FT_SFX_REPEAT,x		;check if repeat counter is not zero
	beq @no_repeat
	dec FT_SFX_REPEAT,x		;decrement and return
	bne @update_buf			;just mix with output buffer

@no_repeat:
	lda FT_SFX_PTR_H,x		;check if MSB of the pointer is not zero
	bne @sfx_active
	rts						;return otherwise, no active effect

@sfx_active:
	sta <FT_TEMP_PTR_H		;load effect pointer into temp
	lda FT_SFX_PTR_L,x
	sta <FT_TEMP_PTR_L
	ldy FT_SFX_OFF,x
	clc

@read_byte:
	lda (FT_TEMP_PTR),y		;read byte of effect
	bmi @get_data			;if bit 7 is set, it is a register write
	beq @eof
	iny
	sta FT_SFX_REPEAT,x		;if bit 7 is reset, it is number of repeats
	tya
	sta FT_SFX_OFF,x
	jmp @update_buf

@get_data:
	iny
	stx <FT_TEMP_VAR1		;it is a register write
	adc <FT_TEMP_VAR1		;get offset in the effect output buffer
	tax
	lda (FT_TEMP_PTR),y		;read value
	iny
	sta FT_SFX_BUF-128,x	;store into output buffer
	ldx <FT_TEMP_VAR1
	jmp @read_byte			;and read next byte

@eof:
	sta FT_SFX_PTR_H,x		;mark channel as inactive

@update_buf:

	lda FT_OUT_BUF			;compare effect output buffer with main output buffer
	and #$0f				;if volume of pulse 1 of effect is higher than that of the
	sta <FT_TEMP_VAR1		;main buffer, overwrite the main buffer value with the new one
	lda FT_SFX_BUF+0,x
	and #$0f
	cmp <FT_TEMP_VAR1
	bcc @no_pulse1
	lda FT_SFX_BUF+0,x
	sta FT_OUT_BUF+0
	lda FT_SFX_BUF+1,x
	sta FT_OUT_BUF+1
	lda FT_SFX_BUF+2,x
	sta FT_OUT_BUF+2
@no_pulse1:

	lda FT_OUT_BUF+3		;same for pulse 2
	and #$0f
	sta <FT_TEMP_VAR1
	lda FT_SFX_BUF+3,x
	and #$0f
	cmp <FT_TEMP_VAR1
	bcc @no_pulse2
	lda FT_SFX_BUF+3,x
	sta FT_OUT_BUF+3
	lda FT_SFX_BUF+4,x
	sta FT_OUT_BUF+4
	lda FT_SFX_BUF+5,x
	sta FT_OUT_BUF+5
@no_pulse2:

	lda FT_SFX_BUF+6,x		;overwrite triangle of main output buffer if it is active
	beq @no_triangle
	sta FT_OUT_BUF+6
	lda FT_SFX_BUF+7,x
	sta FT_OUT_BUF+7
	lda FT_SFX_BUF+8,x
	sta FT_OUT_BUF+8
@no_triangle:

	lda FT_OUT_BUF+9		;same as for pulse 1 and 2, but for noise
	and #$0f
	sta <FT_TEMP_VAR1
	lda FT_SFX_BUF+9,x
	and #$0f
	cmp <FT_TEMP_VAR1
	bcc @no_noise
	lda FT_SFX_BUF+9,x
	sta FT_OUT_BUF+9
	lda FT_SFX_BUF+10,x
	sta FT_OUT_BUF+10
@no_noise:

	rts
    .endif

;PAL and NTSC, 11-bit dividers
;rest note, then octaves 1-5, then three zeroes
;first 64 bytes are PAL, next 64 bytes are NTSC

_FT2NoteTableLSB:
	.if(FT_PAL_SUPPORT)
	.byte $00,$33,$da,$86,$36,$eb,$a5,$62,$23,$e7,$af,$7a,$48,$19,$ec,$c2
	.byte $9a,$75,$52,$30,$11,$f3,$d7,$bc,$a3,$8c,$75,$60,$4c,$3a,$28,$17
	.byte $08,$f9,$eb,$dd,$d1,$c5,$ba,$af,$a5,$9c,$93,$8b,$83,$7c,$75,$6e
	.byte $68,$62,$5c,$57,$52,$4d,$49,$45,$41,$3d,$3a,$36,$33,$30,$2d,$2b
	.endif
	.if(FT_NTSC_SUPPORT)
	.byte $00,$ad,$4d,$f2,$9d,$4c,$00,$b8,$74,$34,$f7,$be,$88,$56,$26,$f8
	.byte $ce,$a5,$7f,$5b,$39,$19,$fb,$de,$c3,$aa,$92,$7b,$66,$52,$3f,$2d
	.byte $1c,$0c,$fd,$ee,$e1,$d4,$c8,$bd,$b2,$a8,$9f,$96,$8d,$85,$7e,$76
	.byte $70,$69,$63,$5e,$58,$53,$4f,$4a,$46,$42,$3e,$3a,$37,$34,$31,$2e
	.endif
_FT2NoteTableMSB:
	.if(FT_PAL_SUPPORT)
	.byte $00,$06,$05,$05,$05,$04,$04,$04,$04,$03,$03,$03,$03,$03,$02,$02
	.byte $02,$02,$02,$02,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.endif
	.if(FT_NTSC_SUPPORT)
	.byte $00,$06,$06,$05,$05,$05,$05,$04,$04,$04,$03,$03,$03,$03,$03,$02
	.byte $02,$02,$02,$02,$02,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.endif
