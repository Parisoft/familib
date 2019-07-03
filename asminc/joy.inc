    .globalzp _joy;
    .global joy_poll;(u8_t);
    .global joy_poll_safe;(u8_t);
    ; For C code
    .global _joy_poll
    .global _joy_poll_safe
    
    .define BUTTON_A %10000000
    .define BUTTON_B %01000000
    .define BUTTON_SELECT %00100000
    .define BUTTON_START %00010000
    .define PAD_UP %00001000
    .define PAD_DOWN %00000100
    .define PAD_LEFT %00000010
    .define PAD_RIGHT %00000001
    .define JOYPAD1 $4016
    .define JOYPAD2 $4017

    .macro joy_pressing idx, btn
    lda joy::curr+idx
    and #btn
    .endmac

    .macro joy_pressed idx, btn
    lda joy::prev+idx
    and #btn
    .endmac

    .struct joy_t
     curr   .res 4  ; current state
     prev   .res 4  ; previous state
    .endstruct

    .scope joy
    curr = _joy+joy_t::curr
    prev = _joy+joy_t::prev
    .endscope