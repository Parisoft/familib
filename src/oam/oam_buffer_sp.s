	.include "oam.inc"

	.importzp sp
	.export _oam_buffer_sp 

	; u8_t __fastcall__ oam_buffer_sp(u8 x, u8 y, u8 sp, u8 fx, u8 num);
	.proc _oam_buffer_sp 
    asl a 
    asl a 
    tax 
	ldy #0		;four popa calls replacement
	lda (sp), y ; LDA fx
	sta OAMBUFF+2, x 
	iny 
	lda (sp), Y ; LDA sp
	sta OAMBUFF+1, x 
	iny 
	lda (sp), Y ; LDA y
	sta OAMBUFF+0, x 
	iny 
	lda (sp), Y ; LDA x
	sta OAMBUFF+3, x 
	lda sp+0 
	clc 
	adc #4
	sta sp+0 
	bcc @done
	inc sp+1 
@done:
	txa
	lsr a
	lsr a
    rts 
	.endproc
