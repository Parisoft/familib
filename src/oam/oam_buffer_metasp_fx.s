	.include "oam.inc"

	.importzp sp, oamptr, oamtmp1, oamtmp2, oamtmp3
	.export _oam_buffer_metasp_fx 


	; u8_t __fastcall__ oam_buffer_metasp_fx(u8 x, u8 y, u8 fx, u8 num, const u8 *meta);
	.proc _oam_buffer_metasp_fx 
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
	sta oamtmp3		; tmp3 = fx
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
	lda (oamptr), y	; LDA meta.sp
	sta OAMBUFF+1, x 
	iny 
	lda (oamptr), y	; LDA meta.fx
	ora oamtmp3 
	sta OAMBUFF+2, x 
	iny 
    .repeat 4
	inx 
	.endrep
	jmp @buffer
@updsp:
	lda sp+0 
	adc #3			;carry is always set here, so it adds 4
	sta sp+0 
	bcc @done
	inc sp+1 
@done:
	txa
	lsr a
	lsr a
    rts 
	.endproc
