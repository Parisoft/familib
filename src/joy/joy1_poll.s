    .include "joy.inc"

    .importzp _joy1 
    .export _joy1_poll 

.proc _joy1_poll 
    lda _joy1+0 
    sta _joy1+1 ; prev = curr
    lda #1
    sta _joy1 
    sta JOYPAD1 
    lsr    
    sta JOYPAD1  
@loop:       
	lda JOYPAD1 
    and #3
    cmp #1
    rol _joy1 
    bcc @loop     
    rts 
.endproc