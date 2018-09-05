    .importzp ppuptr1 
    .export _ppu_load_attr_table 

    .include "ppu.inc"

; void __fastcall__ ppu_load_attr_table(u16 nt, const u8 *data);
.proc _ppu_load_attr_table 
	sta ppuptr1+0	; ptr1 = *data
	stx ppuptr1+1 
	ldy #1
	lda (sp), y	; LDA nt+1
	adc #>$03C0
	sta PPUADDR 
	lda #<$03C0
	sta PPUADDR 
	dey 
@loop:
	lda (ppuptr1), y
	sta PPUDATA 
	iny 
	cpy #64
	bne @loop
	updsp 2
	rts 
.endproc
