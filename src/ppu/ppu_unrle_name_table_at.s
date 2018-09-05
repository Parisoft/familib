    .importzp sp, ppuptr1, pputmp1, pputmp2 
    .export _ppu_unrle_name_table_at 

    .include "ppu.inc"

; void __fastcall__ ppu_unrle_name_table_at(u16_t nt, u8_t *data)
.proc _ppu_unrle_name_table_at 
	pha 
	stx ppuptr1+1 
	lda #0
	sta ppuptr1+0 

    ldy #1
	lda (sp), y	; LDA nt+1    
	sta PPUADDR       
	dey 
	lda (sp), y	; LDA nt+0
	sta PPUADDR   

    pla 
    tay 
	lda (ppuptr1), y
	sta pputmp1 
	iny 
	bne @step1
	inc ppuptr1+1 
@step1:
	lda (ppuptr1), y
	iny 
	bne @step1_1
	inc ppuptr1+1 
@step1_1:
	cmp pputmp1 
	beq @step2
	sta PPUDATA 
	sta pputmp2 
	bne @step1
@step2:
	lda (ppuptr1), y
	beq @step4
	iny 
	bne @step2_1
	inc ppuptr1+1 
@step2_1:
	tax 
	lda pputmp2 
@step3:
	sta PPUDATA 
	dex 
	bne @step3
	beq @step1
@step4:
    updsp 1
	rts 
.endproc