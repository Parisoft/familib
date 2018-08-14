    .importzp _joy2 
    .export _joy2_poll_safe 

JOYPAD1 = $4016
JOYPAD2 = $4017

.proc joy2poll 
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
    lda _joy2 
    rts 
.endproc

.proc _joy2_poll_safe 
    lda _joy2 
    pha 
    jsr joy2poll 
    tax             ; x = poll1   
    jsr joy2poll 
    sta _joy2+1     ; _joy2+1 = poll2
    jsr joy2poll 
    tay             ; y = poll3
    jsr joy2poll    ; a, _joy2+0 = poll4   
    cmp _joy2+1     ; poll4 == poll2 ?   
    beq @done
    stx _joy2+0     ; _joy2+0 = poll1    
    cpx _joy2+1     ; poll1 == poll2 ?    
    beq @done    
    sty _joy2+0     ; _joy2+0 = poll3        
@done: 
    pla 
    sta _joy2+1     ; prev = curr
    rts 
.endproc