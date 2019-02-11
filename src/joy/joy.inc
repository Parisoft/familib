    .define BUTTON_A 1 << 7
    .define BUTTON_B 1 << 6
    .define BUTTON_SELECT 1 << 5
    .define BUTTON_START 1 << 4
    .define PAD_UP 1 << 3
    .define PAD_DOWN 1 << 2
    .define PAD_LEFT 1 << 1
    .define PAD_RIGHT 1 << 0

    .define JOYPAD1 $4016
    .define JOYPAD2 $4017

    .struct joy_t
     curr   .res 1  ; current state
     prev   .res 1  ; previous state
    .endstruct

    .define joy1_curr    _joy1+joy_t::curr
    .define joy1_prev    _joy1+joy_t::prev
    .define joy2_curr    _joy2+joy_t::curr
    .define joy2_prev    _joy2+joy_t::prev