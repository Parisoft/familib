	.importzp sp, oamptr, oamtmp1, oamtmp2, oamtmp3 
	.export _oam_buffer_metaspr 

OAMBUFF = $0200
OAMADDR = $2003
OAMDATA = $2004
OAMDMA  = $4014

; void __fastcall__ oam_buffer_metaspr(u8 x, u8 y, u8 opt, u8 num, const u8 *meta);
.proc _oam_buffer_metaspr 
    sta oamptr+0 
	stx oamptr+1 
	ldy #3		
	lda (sp), y 
	sta oamtmp1		; tmp1 = x
	dey 
	lda (sp), y 
	sta oamtmp2		; tmp2 = y
	dey 
	lda (sp), y
	sta oamtmp3		; tmp3 = opt
	dey 
	lda (sp), y 
	asl a 
	asl a 
	tax				; X = num
@buffer:
	lda (oamptr), y	; LDA meta.x
	cmp #$80
	beq @updsp
	clc 
	adc oamtmp1 
	sta OAMBUFF+3, x 
	iny 
	lda (oamptr), y	; LDA meta.y
	clc 
	adc oamtmp2 
	sta OAMBUFF+0, x 
	iny 
	lda (oamptr), y	; LDA meta.spr
	sta OAMBUFF+1, x 
	iny 
	lda (oamptr), y	; LDA meta.opt
	ora oamtmp3 
	sta OAMBUFF+2, x 
	iny 
    .repeat 4
	inx 
	.endrepeat
	jmp @buffer
@updsp:
	lda sp+0 
	adc #3			;carry is always set here, so it adds 4
	sta sp+0 
	bcc @done
	inc sp+1 
@done:
    rts 
.endproc
