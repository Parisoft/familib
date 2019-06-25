    .include "ft2.inc"

    .segment "CODE"

ft2_stop_sample = FamiToneSampleStop
_ft2_stop_sample = FamiToneSampleStop

;------------------------------------------------------------------------------
; stop DPCM sample if it plays
;------------------------------------------------------------------------------

FamiToneSampleStop:

	lda #%00001111
	sta APU_SND_CHN

	rts
