    .include "joy.inc"

joy_poll_safe = _joy_poll_safe

    ;void __fastcall__ joy_poll_safe(u8_t)
    .proc _joy_poll_safe
    tax 
    lda joy::curr, x 
    pha             ; preserve current state
    jsr joypoll 
    tay             ; Y = poll1   
    jsr joypoll 
    sta joy::prev, x   ; joy::prev = poll2
    jsr joypoll 
    pha             ; preserve poll3
    jsr joypoll     ; A and joy::curr = poll4   
    cmp joy::prev, x     ; poll4 == poll2 ?   
    beq @done
    tya
    sta joy::curr, x     ; joy::curr = poll1    
    cmp joy::prev, x     ; poll1 == poll2 ?    
    beq @done
    pla    
    sta joy::curr, x     ; joy::curr = poll3
    pla
    sta joy::prev, x     ; prev = curr
    rts         
@done: 
    pla                  ; discard poll3
    pla
    sta joy::prev, x     ; prev = curr
    rts 
    .endproc

    ; X -> joy num
    .proc joypoll
    lda #1
    sta joy::curr, x 
    sta JOYPAD1 
    lsr a
    sta JOYPAD1  
@loop:       
	lda JOYPAD1 
    and #3
    cmp #1
    rol joy::curr, x 
    bcc @loop
    lda joy::curr, x 
    rts 
    .endproc
