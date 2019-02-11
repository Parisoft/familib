    .include "joy.inc"
    
    .importzp _joy2 
    .export _joy2_poll 

.proc _joy2_poll 
    lda _joy2+0 
    sta _joy2+1 ; prev = curr
    lda #1
    sta _joy2 
    sta JOYPAD1 
    lsr    
    sta JOYPAD1  
@loop:       
	lda JOYPAD2 
    and #3
    cmp #1
    rol _joy2 
    bcc @loop     
    rts 
.endproc