	.global FamiToneInit, _ft2_init_ntsc, _ft2_init_palm, _ft2_init, ft2_init
    .global FamiToneSfxInit, _ft2_init_sfx, ft2_init_sfx
    .global FamiToneMusicPlay, _ft2_play_music, ft2_play_music
    .global FamiToneMusicStop, _ft2_stop_music, ft2_stop_music
    .global FamiToneMusicPause, _ft2_pause_music, ft2_pause_music
    .global FamiToneSfxPlay, _ft2_play_sfx, ft2_play_sfx
    .global FamiToneSamplePlay, FamiToneSamplePlayM, _ft2_play_sample, ft2_play_sample
    .global FamiToneSampleStop, _ft2_stop_sample, ft2_stop_sample
    .global FamiToneUpdate, _ft2_update, ft2_update 

	.globalzp ft2zp
	.global ft2bss

FT_TEMP			= ft2zp		;3 bytes in zeropage used by the library as a scratchpad
FT_BASE_ADR		= ft2bss	;page in the RAM used for FT2 variables, should be $xx00
FT_DPCM_OFF		= $C000	    ;$c000..$ffc0, 64-byte steps
FT_SFX_STREAMS	= 4		    ;number of sound effects played at once, 1..4
FT_DPCM_ENABLE	= 1			;undefine to exclude all DMC code
FT_SFX_ENABLE	= 1			;undefine to exclude all sound effects code
FT_THREAD		= 1			;undefine if you are calling sound effects from the same thread as the sound update call
FT_PAL_SUPPORT	= 1			;undefine to exclude PAL support
FT_NTSC_SUPPORT	= 1			;undefine to exclude NTSC support

;internal defines

	.if(FT_PAL_SUPPORT)
	.if(FT_NTSC_SUPPORT)
FT_PITCH_FIX = (FT_PAL_SUPPORT|FT_NTSC_SUPPORT)			;add PAL/NTSC pitch correction code only when both modes are enabled
	.endif
	.endif

FT_DPCM_PTR		= (FT_DPCM_OFF&$3fff)>>6


;zero page variables

FT_TEMP_PTR			= FT_TEMP		;word
FT_TEMP_PTR_L		= FT_TEMP_PTR+0
FT_TEMP_PTR_H		= FT_TEMP_PTR+1
FT_TEMP_VAR1		= FT_TEMP+2
FT_TEMP_SIZE        = 3

;envelope structure offsets, 5 bytes per envelope, grouped by variable type

FT_ENVELOPES_ALL	= 3+3+3+2	;3 for the pulse and triangle channels, 2 for the noise channel
FT_ENV_STRUCT_SIZE	= 5

FT_ENV_VALUE		= FT_BASE_ADR+0*FT_ENVELOPES_ALL
FT_ENV_REPEAT		= FT_BASE_ADR+1*FT_ENVELOPES_ALL
FT_ENV_ADR_L		= FT_BASE_ADR+2*FT_ENVELOPES_ALL
FT_ENV_ADR_H		= FT_BASE_ADR+3*FT_ENVELOPES_ALL
FT_ENV_PTR			= FT_BASE_ADR+4*FT_ENVELOPES_ALL


;channel structure offsets, 7 bytes per channel

FT_CHANNELS_ALL		= 5
FT_CHN_STRUCT_SIZE	= 9

FT_CHN_PTR_L		= FT_BASE_ADR+0*FT_CHANNELS_ALL
FT_CHN_PTR_H		= FT_BASE_ADR+1*FT_CHANNELS_ALL
FT_CHN_NOTE			= FT_BASE_ADR+2*FT_CHANNELS_ALL
FT_CHN_INSTRUMENT	= FT_BASE_ADR+3*FT_CHANNELS_ALL
FT_CHN_REPEAT		= FT_BASE_ADR+4*FT_CHANNELS_ALL
FT_CHN_RETURN_L		= FT_BASE_ADR+5*FT_CHANNELS_ALL
FT_CHN_RETURN_H		= FT_BASE_ADR+6*FT_CHANNELS_ALL
FT_CHN_REF_LEN		= FT_BASE_ADR+7*FT_CHANNELS_ALL
FT_CHN_DUTY			= FT_BASE_ADR+8*FT_CHANNELS_ALL


;variables and aliases

FT_ENVELOPES	= FT_BASE_ADR
FT_CH1_ENVS		= FT_ENVELOPES+0
FT_CH2_ENVS		= FT_ENVELOPES+3
FT_CH3_ENVS		= FT_ENVELOPES+6
FT_CH4_ENVS		= FT_ENVELOPES+9

FT_CHANNELS		= FT_ENVELOPES+FT_ENVELOPES_ALL*FT_ENV_STRUCT_SIZE
FT_CH1_VARS		= FT_CHANNELS+0
FT_CH2_VARS		= FT_CHANNELS+1
FT_CH3_VARS		= FT_CHANNELS+2
FT_CH4_VARS		= FT_CHANNELS+3
FT_CH5_VARS		= FT_CHANNELS+4


FT_CH1_NOTE			= FT_CH1_VARS+.lobyte(FT_CHN_NOTE)
FT_CH2_NOTE			= FT_CH2_VARS+.lobyte(FT_CHN_NOTE)
FT_CH3_NOTE			= FT_CH3_VARS+.lobyte(FT_CHN_NOTE)
FT_CH4_NOTE			= FT_CH4_VARS+.lobyte(FT_CHN_NOTE)
FT_CH5_NOTE			= FT_CH5_VARS+.lobyte(FT_CHN_NOTE)

FT_CH1_INSTRUMENT	= FT_CH1_VARS+.lobyte(FT_CHN_INSTRUMENT)
FT_CH2_INSTRUMENT	= FT_CH2_VARS+.lobyte(FT_CHN_INSTRUMENT)
FT_CH3_INSTRUMENT	= FT_CH3_VARS+.lobyte(FT_CHN_INSTRUMENT)
FT_CH4_INSTRUMENT	= FT_CH4_VARS+.lobyte(FT_CHN_INSTRUMENT)
FT_CH5_INSTRUMENT	= FT_CH5_VARS+.lobyte(FT_CHN_INSTRUMENT)

FT_CH1_DUTY			= FT_CH1_VARS+.lobyte(FT_CHN_DUTY)
FT_CH2_DUTY			= FT_CH2_VARS+.lobyte(FT_CHN_DUTY)
FT_CH3_DUTY			= FT_CH3_VARS+.lobyte(FT_CHN_DUTY)
FT_CH4_DUTY			= FT_CH4_VARS+.lobyte(FT_CHN_DUTY)
FT_CH5_DUTY			= FT_CH5_VARS+.lobyte(FT_CHN_DUTY)

FT_CH1_VOLUME		= FT_CH1_ENVS+.lobyte(FT_ENV_VALUE)+0
FT_CH2_VOLUME		= FT_CH2_ENVS+.lobyte(FT_ENV_VALUE)+0
FT_CH3_VOLUME		= FT_CH3_ENVS+.lobyte(FT_ENV_VALUE)+0
FT_CH4_VOLUME		= FT_CH4_ENVS+.lobyte(FT_ENV_VALUE)+0

FT_CH1_NOTE_OFF		= FT_CH1_ENVS+.lobyte(FT_ENV_VALUE)+1
FT_CH2_NOTE_OFF		= FT_CH2_ENVS+.lobyte(FT_ENV_VALUE)+1
FT_CH3_NOTE_OFF		= FT_CH3_ENVS+.lobyte(FT_ENV_VALUE)+1
FT_CH4_NOTE_OFF		= FT_CH4_ENVS+.lobyte(FT_ENV_VALUE)+1

FT_CH1_PITCH_OFF	= FT_CH1_ENVS+.lobyte(FT_ENV_VALUE)+2
FT_CH2_PITCH_OFF	= FT_CH2_ENVS+.lobyte(FT_ENV_VALUE)+2
FT_CH3_PITCH_OFF	= FT_CH3_ENVS+.lobyte(FT_ENV_VALUE)+2


FT_VARS			= FT_CHANNELS+FT_CHANNELS_ALL*FT_CHN_STRUCT_SIZE

FT_PAL_ADJUST	= FT_VARS+0
FT_SONG_LIST_L	= FT_VARS+1
FT_SONG_LIST_H	= FT_VARS+2
FT_INSTRUMENT_L = FT_VARS+3
FT_INSTRUMENT_H = FT_VARS+4
FT_TEMPO_STEP_L	= FT_VARS+5
FT_TEMPO_STEP_H	= FT_VARS+6
FT_TEMPO_ACC_L	= FT_VARS+7
FT_TEMPO_ACC_H	= FT_VARS+8
FT_SONG_SPEED	= FT_CH5_INSTRUMENT
FT_PULSE1_PREV	= FT_CH3_DUTY
FT_PULSE2_PREV	= FT_CH5_DUTY
FT_DPCM_LIST_L	= FT_VARS+9
FT_DPCM_LIST_H	= FT_VARS+10
FT_DPCM_EFFECT  = FT_VARS+11
FT_OUT_BUF		= FT_VARS+12	;11 bytes


;sound effect stream variables, 2 bytes and 15 bytes per stream
;when sound effects are disabled, this memory is not used

FT_SFX_ADR_L		= FT_VARS+23
FT_SFX_ADR_H		= FT_VARS+24
FT_SFX_BASE_ADR		= FT_VARS+25

FT_SFX_STRUCT_SIZE	= 15
FT_SFX_REPEAT		= FT_SFX_BASE_ADR+0
FT_SFX_PTR_L		= FT_SFX_BASE_ADR+1
FT_SFX_PTR_H		= FT_SFX_BASE_ADR+2
FT_SFX_OFF			= FT_SFX_BASE_ADR+3
FT_SFX_BUF			= FT_SFX_BASE_ADR+4	;11 bytes

FT_BASE_SIZE 		= FT_SFX_BUF+11-FT_BASE_ADR

;aliases for sound effect channels to use in user calls

FT_SFX_CH0			= FT_SFX_STRUCT_SIZE*0
FT_SFX_CH1			= FT_SFX_STRUCT_SIZE*1
FT_SFX_CH2			= FT_SFX_STRUCT_SIZE*2
FT_SFX_CH3			= FT_SFX_STRUCT_SIZE*3


;aliases for the APU registers

APU_PL1_VOL		= $4000
APU_PL1_SWEEP	= $4001
APU_PL1_LO		= $4002
APU_PL1_HI		= $4003
APU_PL2_VOL		= $4004
APU_PL2_SWEEP	= $4005
APU_PL2_LO		= $4006
APU_PL2_HI		= $4007
APU_TRI_LINEAR	= $4008
APU_TRI_LO		= $400a
APU_TRI_HI		= $400b
APU_NOISE_VOL	= $400c
APU_NOISE_LO	= $400e
APU_NOISE_HI	= $400f
APU_DMC_FREQ	= $4010
APU_DMC_RAW		= $4011
APU_DMC_START	= $4012
APU_DMC_LEN		= $4013
APU_SND_CHN		= $4015


;aliases for the APU registers in the output buffer

	.if(!FT_SFX_ENABLE)				;if sound effects are disabled, write to the APU directly
FT_MR_PULSE1_V		= APU_PL1_VOL
FT_MR_PULSE1_L		= APU_PL1_LO
FT_MR_PULSE1_H		= APU_PL1_HI
FT_MR_PULSE2_V		= APU_PL2_VOL
FT_MR_PULSE2_L		= APU_PL2_LO
FT_MR_PULSE2_H		= APU_PL2_HI
FT_MR_TRI_V			= APU_TRI_LINEAR
FT_MR_TRI_L			= APU_TRI_LO
FT_MR_TRI_H			= APU_TRI_HI
FT_MR_NOISE_V		= APU_NOISE_VOL
FT_MR_NOISE_F		= APU_NOISE_LO
	.else								;otherwise write to the output buffer
FT_MR_PULSE1_V		= FT_OUT_BUF
FT_MR_PULSE1_L		= FT_OUT_BUF+1
FT_MR_PULSE1_H		= FT_OUT_BUF+2
FT_MR_PULSE2_V		= FT_OUT_BUF+3
FT_MR_PULSE2_L		= FT_OUT_BUF+4
FT_MR_PULSE2_H		= FT_OUT_BUF+5
FT_MR_TRI_V			= FT_OUT_BUF+6
FT_MR_TRI_L			= FT_OUT_BUF+7
FT_MR_TRI_H			= FT_OUT_BUF+8
FT_MR_NOISE_V		= FT_OUT_BUF+9
FT_MR_NOISE_F		= FT_OUT_BUF+10
	.endif
