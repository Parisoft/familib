; startup code for cc65/ca65

    .import _main, _nmi, _irq 
    .export __STARTUP__:absolute=1

PPUCTRL     = $2000
PPUMASK     = $2001
PPUSTATUS   = $2002
OAMADDRESS  = $2003
OAMDMA      = $4014
APUDMC      = $4010
APUSTATUS   = $4015
APUFRAME    = $4017
STACK_SIZE  = $100

    .segment "BSS"

cstack: .res STACK_SIZE 

    .segment "STARTUP"

.proc reset 
    .ifdef IRQ_ON 
    cli             ; Enable interrupts
    .else
    sei             ; Disable interrupts
    .endif
    cld             ; Disabel decimal mode
    ldx #$FF
    txs             ; Set up stack
    inx 
    stx PPUCTRL     ; Disable NMI and set VRAM increment to 32
    stx PPUMASK     ; Disable rendering
    stx APUDMC      ; Disable DMC IRQ
    bit PPUSTATUS   ; Acknowledge stray vblank NMI across reset
    bit APUSTATUS   ; Acknowledge DMC IRQ
    lda #$40
    sta APUFRAME    ; Disable APU Frame IRQ
    lda #$0F
    sta APUSTATUS   ; Disable DMC playback, initialize other channels

@vwait1:
    bit PPUSTATUS   ; It takes one full frame for the PPU to become
    bpl @vwait1      ; stable.  Wait for the first frame's vblank.

    ; We now have about 30,000 cycles to burn before the PPU stabilizes.

    txa 
@clear_ram:
    sta $00, x
    sta $0100, x
    sta $0300, x
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x
    inx 
    bne @clear_ram

	; Initialize OAM data in $0200 to have all y coordinates off-screen
	; (e.g. set every fourth byte starting at $0200 to $ef)
	lda #$ef
@clear_oam:
	sta $0200, x
    .repeat 4
	inx 
    .endrepeat
	bne @clear_oam

    ; Second of two waits for vertical blank to make sure that the
    ; PPU has stabilized
@vwait2:
    bit PPUSTATUS 
    bpl @vwait2

	; initialize PPU OAM
    stx OAMADDRESS ; $00
    lda #$02 ; use page $0200-$02ff
    sta OAMDMA 

    ; set the C stack pointer
    lda #<(cstack + STACK_SIZE)
    sta sp+0 
    lda #>(cstack + STACK_SIZE)
    sta sp+1 

	lda PPUSTATUS ; reset the PPU latch

    jmp _main ; call into our C main()
.endproc

    .segment "VECTORS"

.word _nmi   ;$fffa NMI
.word reset  ;$fffc Reset
.word _irq   ;$fffe IRQ

