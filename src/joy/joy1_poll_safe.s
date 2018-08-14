    .importzp _joy1 
    .export _joy1_poll_safe 

JOYPAD1 = $4016

.proc joy1poll 
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
    lda _joy1 
    rts 
.endproc

.proc _joy1_poll_safe 
    lda _joy1 
    pha 
    jsr joy1poll 
    tax             ; x = poll1   
    jsr joy1poll 
    sta _joy1+1     ; _joy1+1 = poll2
    jsr joy1poll 
    tay             ; y = poll3
    jsr joy1poll    ; a, _joy1+0 = poll4   
    cmp _joy1+1     ; poll4 == poll2 ?   
    beq @done
    stx _joy1+0     ; _joy1+0 = poll1    
    cpx _joy1+1     ; poll1 == poll2 ?    
    beq @done    
    sty _joy1+0     ; _joy1+0 = poll3        
@done: 
    pla 
    sta _joy1+1     ; prev = curr
    rts 
.endproc