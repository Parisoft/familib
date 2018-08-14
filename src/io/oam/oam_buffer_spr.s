	.importzp sp 
	.export _oam_buffer_spr 

OAMBUFF = $0200
OAMADDR = $2003
OAMDATA = $2004
OAMDMA  = $4014

;extern void __fastcall__ oam_buffer_spr(u8 x, u8 y, u8 spr, u8 opt, u8 num);
.proc _oam_buffer_spr 
    asl a 
    asl a 
    tax 
	ldy #0		;four popa calls replacement
	lda (sp), y ; LDA opt
	sta OAMBUFF+2, x 
	iny 
	lda (sp), Y ; LDA spr
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
    rts 
.endproc
