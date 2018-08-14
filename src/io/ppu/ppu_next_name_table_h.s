    .importzp _ppu 
    .export _ppu_next_name_table_h 

ctrl = _ppu+0 

; u16 __fastcall__ ppu_next_name_table_h();
.proc _ppu_next_name_table_h 
	lda ctrl 
	and #%00000011
	eor #%00000001
	asl A 
	asl A 
	clc 
	adc #$20
	tax 
	lda #0
	rts 
.endproc
