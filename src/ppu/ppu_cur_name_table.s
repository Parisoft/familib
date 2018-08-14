    .importzp _ppu 
    .export _ppu_cur_name_table 

ctrl = _ppu+0 

; u16 __fastcall__ ppu_cur_name_table();
.proc _ppu_cur_name_table 
	lda ctrl 
	and #%00000011
	asl A 
	asl A 
	clc 
	adc #$20
	tax 
	lda #0
	rts 
.endproc
