    .include "joy.inc"

joy_poll = _joy_poll

    ;void __fastcall__ joy_poll(u8_t)
    .proc _joy_poll
    tax
    lda joy::curr, x 
    sta joy::prev, x ; prev = curr
    lda #1
    sta joy::curr, x
    sta JOYPAD1
    lsr a 
    sta JOYPAD1
@loop:       
    lda JOYPAD1, x
    and #3
    cmp #1
    rol joy::curr, x 
    bcc @loop     
    rts 
    .endproc