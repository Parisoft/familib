	.exportzp _ppu 

	.segment "ZEROPAGE"
_ppu:		.res 5	; 0:ctrl, 1:mask, 2:scrollX, 3:scrollY, 4:system

;TODO refactor
; 	.segment "CODE"
; .importzp sp, ptr1, ptr2, tmp1, tmp2, tmp3, tmp4, _ppuctrl 

; PPUCTRL   = $2000
; PPUSTATUS = $2002
; PPUADDR   = $2006
; PPUDATA   = $2007
; SCREEN_ROWS = 30
; SCREEN_COLS = 32

; .macro pop_a 
; 	LDY #0
; 	LDA (sp), Y 
; 	INC sp 
; 	BNE :+ 
; 	INC sp+1 
; :
; .endmacro

; .macro updsp n 
; 	CLC 
; 	LDA sp+0 
; 	ADC #n 
; 	STA sp+0 
; 	BCC :+ 
; 	INC sp+1
; : 
; .endmacro

; ;extern void __fastcall__ ppu_load_bg_pal(const u8 *data);
; .export _ppu_load_bg_pal 

; .proc _ppu_load_bg_pal 
;     STA ptr1+0 
;     STX ptr1+1 
; 	LDA #>$3F00         
; 	STA PPUADDR 
; 	LDA #<$3F00         
; 	STA PPUADDR 
; 	LDY #0           
; @loop:                  
; 	LDA (ptr1), Y 
; 	STA PPUDATA 
; 	INY                 
;     CPY #16           
; 	BNE @loop           
; 	RTS 
; .endproc

; ;extern void __fastcall__ ppu_load_bg_pal_at(u8 idx, const u8 *data)
; .export _ppu_load_bg_pal_at 

; .proc _ppu_load_bg_pal_at 
; 	STA ptr1+0 
; 	STX ptr1+1 
; 	LDA #>$3F00         
; 	STA PPUADDR      
; 	pop_a	; LDA idx         
; 	ASL A               
; 	ASL A               
; 	CLC                 
; 	ADC #<$3F00         
; 	STA PPUADDR 
; 	LDY #0              
; @loop:                 
; 	LDA (ptr1), Y  
; 	STA PPUDATA      
; 	INY                 
; 	CPY #4              
; 	BNE @loop
; 	RTS        	
; .endproc

; ;extern void __fastcall__ ppu_load_bg_pal_color(u8 idx, u8 color);
; .export _ppu_load_bg_pal_color 

; .proc _ppu_load_bg_pal_color 
; 	TAX 
; 	LDA #>$3F00   
; 	STA PPUADDR 
; 	pop_a ; LDA idx     
; 	CLC           
; 	ADC #<$3F00   
; 	STA PPUADDR 
; 	STX PPUDATA 
; 	RTS 
; .endproc

; ;extern void __fastcall__ ppu_load_spr_pal(const u8 *data);
; .export _ppu_load_spr_pal 

; .proc _ppu_load_spr_pal 
; 	STA ptr1+0 
; 	STX ptr1+1 
; 	LDA #>$3F10         
; 	STA PPUADDR      
; 	LDA #<$3F10         
; 	STA PPUADDR      
; 	LDY #0            
; @loop:                 
; 	LDA (ptr1), Y 
; 	STA PPUDATA      
; 	INY                 
; 	CPY #16            
; 	BNE @loop           
; 	RTS 
; .endproc

; ;extern void __fastcall__ ppu_load_spr_pal_at(u8 idx, const u8 *data);
; .export _ppu_load_spr_pal_at 

; .proc _ppu_load_spr_pal_at 
; 	STA ptr1+0 
; 	STX ptr1+1 
; 	LDA #>$3F10         
; 	STA PPUADDR      
; 	pop_a ; LDA idx
; 	ASL A               
; 	ASL A               
; 	CLC                 
; 	ADC #<$3F10         
; 	STA PPUADDR      
; 	LDY #0              
; @loop:                 
; 	LDA (ptr1), Y  
; 	STA PPUDATA      
; 	INY                 
; 	CPY #4              
; 	BNE @loop            
; 	RTS 
; .endproc

; ;extern void __fastcall__ ppu_load_spr_pal_color(u8 idx, u8 color);
; .export _ppu_load_spr_pal_color 

; .proc _ppu_load_spr_pal_color 
; 	TAX 
; 	LDA #>$3F10    
; 	STA PPUADDR 
; 	pop_a ; LDA idx 
; 	CLC            
; 	ADC #<$3F10    
; 	STA PPUADDR 
; 	STX PPUDATA 
; 	RTS 
; .endproc

; ;extern void __fastcall__ ppu_load_name_table(u16 nt, const u8 *data);
; .export _ppu_load_name_table 

; .proc _ppu_load_name_table 
; 	STA ptr1+0 
; 	STX ptr1+1 
; 	LDA PPUSTATUS 
; 	LDY #1
; 	LDA (sp), Y	; LDA nt+1    
; 	STA PPUADDR       
; 	DEY 
; 	LDA (sp), Y	; LDA nt+0
; 	STA PPUADDR       
; 	LDX #3               
; @loop:                  
; 	LDA (ptr1), Y 
; 	STA PPUDATA       
; 	INY                  
; 	BNE @loop            
; 	INC ptr1+1 
; 	DEX                  
; 	BNE @loop            
; @frag:                  
; 	LDA (ptr1), Y 
; 	STA PPUDATA       
; 	INY                  
; 	CPY #$C0             
; 	BNE @frag  
; 	updsp 1
; 	RTS 
; .endproc

; ;extern void __fastcall__ ppu_load_name_table_tile(u8 tile, u16 nt, u8 row, u8 col);
; .export _ppu_load_name_table_tile 

; .proc _ppu_load_name_table_tile 
; 	STA tmp1 	; tmp1 = col 
; 	LDY #0
; 	STY tmp2 
; 	LDA (sp), Y	; LDA row
; 	.repeat 5	; row *= 32
; 	ASL A 
; 	ROL tmp2 
; 	.endrepeat
; 	CLC 		; row += col
; 	ADC tmp1 
; 	STA tmp1 
; 	LDA #0
; 	ADC tmp2 
; 	STA tmp2 
; 	INY 
; 	LDA (sp), Y	; LDA nt+0
; 	CLC 
; 	ADC tmp1 
; 	STA tmp1 
; 	INY 
; 	LDA (sp), Y	; LDA nt+1 
; 	ADC tmp2 
; 	STA PPUADDR             
; 	LDA tmp1        
; 	STA PPUADDR        
; 	LDA PPUSTATUS     
; 	INY 
; 	LDA (sp), Y	; LDA tile                
; 	STA PPUDATA    
; 	updsp 4         
; 	RTS 
; .endproc

; ;extern void __fastcall__ ppu_load_name_table_row(u16 nt, u8 row, const u8 *data);
; .export _ppu_load_name_table_row 

; .proc _ppu_load_name_table_row 
; 	STA ptr1+0	; ptr1 = *data
; 	STX ptr1+1 
; 	LDY #0
; 	LDA (sp), Y	; LDA row
; 	STY tmp2	; tmp2 = >offset
; 	.repeat 5	; offset = row * 32
; 	ASL A 
; 	ROL tmp2 
; 	.endrepeat
; 	STA tmp1	; tmp1 = <offset
; 	CLC 
; 	ADC ptr1+0 
; 	STA ptr1+0 
; 	LDA tmp2 
; 	ADC ptr1+1 
; 	STA ptr1+1 
; 	INY 
; 	LDA (sp), Y	; LDA nt+0
; 	CLC 
; 	ADC tmp1 
; 	STA tmp3	; tmp3 <nt
; 	INY 
; 	LDA (sp), Y	; LDA nt+1
; 	ADC tmp2 
; 	STA PPUADDR 
; 	LDA tmp3 
; 	STA PPUADDR 
; 	LDA PPUSTATUS 
; 	LDY #0
; @loop:
; 	LDA (ptr1), Y 
; 	STA PPUDATA 
; 	INY 
; 	CPY #SCREEN_COLS	
; 	BNE @loop
; 	updsp 3
; 	RTS 
; .endproc

; ;extern void __fastcall__ ppu_load_name_table_col(u16 nt, u8 col, const u8 *data);
; .export _ppu_load_name_table_col 

; .proc _ppu_load_name_table_col 
; 	STA ptr1+0	; ptr1 = *data
; 	STX ptr1+1 
; 	LDA #%00000100	; vram inc by 32 going down
; 	STA PPUCTRL 
; 	LDA PPUSTATUS 
; 	LDY #2
; 	LDA (sp), Y	; LDA nt+1
; 	STA PPUADDR 
; 	DEY 
; 	DEY 
; 	LDA (sp), Y	; LDA col
; 	STA PPUADDR 
; 	LDX #SCREEN_ROWS	
; @loop:
; 	CLC 
; 	ADC ptr1+0 
; 	STA ptr1+0 
; 	BCC @skip 
; 	INC ptr1+1 
; @skip:
;     LDA (ptr1), Y 
; 	STA	PPUDATA 
; 	LDA #SCREEN_COLS 
; 	DEX 
; 	BNE @loop
; 	LDA _ppuctrl 
; 	STA PPUCTRL 
; 	updsp 3
; 	RTS 
; .endproc

; ;extern void __fastcall__ ppu_load_name_table_section(u16 nt, u8 row, u8 col, u8 len0, u8 len1, const u8 *section);
; .export _ppu_load_name_table_section 

; .proc _ppu_load_name_table_section 
; 	STA ptr1+0	; ptr1 = *section
; 	STX ptr1+1 
; 	LDY #0		; 6 popa from len1 to nt
; 	LDA (sp), Y	; LDA len1
; 	STA tmp4	; tmp4 = len1
; 	INY 
; 	LDA (sp), Y	; LDA len0
; 	STA tmp3	; tmp3 = len0
; 	INY 
; 	LDA (sp), Y	; LDA col
; 	STA tmp1 	; tmp1 = col 
; 	LDA #0
; 	STA tmp2 
; 	INY 
; 	LDA (sp), Y	; LDA row
; 	.repeat 5	; row *= 32
; 	ASL A 
; 	ROL tmp2 
; 	.endrepeat
; 	CLC 		; row += col
; 	ADC tmp1 	; tmp1 = <offset
; 	STA tmp1 
; 	LDA #0
; 	ADC tmp2 	; tmp2 = >offset
; 	STA tmp2 
; 	LDA PPUSTATUS 
; 	INY 
; 	LDA (sp), Y	; LDA nt+0
; 	CLC 
; 	ADC tmp1 
; 	STA ptr2+0	; ptr2 = nt + offset
; 	INY 
; 	LDA (sp), Y	; LDA nt+1
; 	ADC tmp2 	
; 	STA ptr2+1 
; 	LDX tmp3 
; 	BNE @loop1	; BRA
; @loop0:
; 	CLC 
; 	LDA ptr1+0 
; 	ADC #SCREEN_COLS 
; 	STA ptr1+0 
; 	BCC @skip
; 	LDA ptr1+1 
; 	ADC #0
; 	STA ptr1+1 
; 	CLC 
; @skip:
; 	LDA ptr2+0 
; 	ADC #SCREEN_COLS		
; 	STA ptr2+0 
; 	LDA ptr2+1 
; 	ADC #0
; 	STA ptr2+1 
; @loop1:
; 	STA PPUADDR 
; 	LDA ptr2+0 
; 	STA PPUADDR 
; 	LDY #0
; @loop2:
; 	LDA (ptr1), Y 
; 	STA PPUDATA 
; 	INY 
; 	CPY tmp4 
; 	BNE @loop2
; 	DEX 
; 	BNE @loop0
; 	updsp 6
; 	RTS 
; .endproc

; ;extern void __fastcall__ ppu_load_attr_table(u16 nt, const u8 *data);
; .export _ppu_load_attr_table 

; .proc _ppu_load_attr_table 
; 	STA ptr1+0	; ptr1 = *data
; 	STX ptr1+1 
; 	LDA PPUSTATUS 
; 	LDY #1
; 	LDA (sp), Y	; LDA nt+1
; 	ADC #>$03C0
; 	STA PPUADDR 
; 	LDA #<$03C0
; 	STA PPUADDR 
; 	DEY 
; @loop:
; 	LDA (ptr1), Y 
; 	STA PPUDATA 
; 	INY 
; 	CPY #64
; 	BNE @loop
; 	updsp 2
; 	RTS 
; .endproc

; ;extern void __fastcall__ ppu_load_attr_table_row(u16 nt, u8 row, const u8 *data);
; .export _ppu_load_attr_table_row 

; .proc _ppu_load_attr_table_row 
; 	STA ptr1+0	; ptr1 = *data
; 	STX ptr1+1 
; 	LDA PPUSTATUS 
; 	LDY #0
; 	LDA (sp), Y	; LDA row
; 	ASL A 
; 	ASL A 
; 	ASL A 
; 	STA tmp1 
; 	CLC 
; 	ADC #<$03C0
; 	TAX 
; 	LDY #2
; 	LDA (sp), Y	; LDA nt+1
; 	ADC #>$03C0
; 	STA PPUADDR 
; 	STX PPUADDR 
; 	LDY tmp1 
; 	LDX #8
; @loop:
; 	LDA (ptr1), Y 
; 	STA PPUDATA 
; 	INY 
; 	DEX 
; 	BNE @loop
; 	updsp 3
; 	RTS 
; .endproc

; ;extern void __fastcall__ ppu_load_attr_table_col(u16 nt, u8 col, const u8 *data);
; .export _ppu_load_attr_table_col 

; .proc _ppu_load_attr_table_col 
; 	STA ptr1+0	; ptr1 = *data
; 	STX ptr1+1 
; 	LDA PPUSTATUS 
; 	LDY #0
; 	LDA (sp), Y	; LDA col
; 	STA tmp1	; tmp1 = col
; 	CLC 
; 	ADC #<$03C0
; 	STA ptr2+0	; ptr2 = nt
; 	LDY #2
; 	LDA (sp), Y	; LDA nt+1
; 	ADC #>$03C0
; 	STA ptr2+1	
; 	LDY tmp1 
; 	LDX #8
; @loop:
; 	STA PPUADDR 
; 	LDA ptr2+0 
; 	STA PPUADDR 
; 	LDA (ptr1), Y 
; 	STA PPUDATA 
; 	DEX 
; 	BEQ @done
; 	TYA 
; 	ADC #8
; 	TAY 
; 	LDA ptr2+0 
; 	ADC #8
; 	STA ptr2+0 
; 	LDA ptr2+1 
; 	BNE @loop
; @done:
; 	updsp 3
; 	RTS 
; .endproc

; ;extern void __fastcall__ ppu_load_attr_table_cell(u8 data, u16 nt, u8 row, u8 col);
; .export _ppu_load_attr_table_cell 

; .proc _ppu_load_attr_table_cell 
; 	STA tmp1	; tmp1 = col
; 	LDA PPUSTATUS 
; 	LDY #0
; 	LDA (sp), Y	; LDA row
; 	ASL A 
; 	ASL A 
; 	ASL A 
; 	CLC 
; 	ADC tmp1 
; 	ADC #<$03C0
; 	STA tmp2	; tmp2 = <nt
; 	LDY #2
; 	LDA (sp), Y	; LDA nt+1
; 	ADC #>$03C0
; 	STA PPUADDR 
; 	LDA tmp2	
; 	STA	PPUADDR 
; 	INY 
; 	LDA (sp), Y	; LDA data
; 	STA PPUDATA 
; 	updsp 4
; 	RTS 
; .endproc

; ;extern u16 __fastcall__ ppu_cur_name_table();
; .export _ppu_cur_name_table 

; .proc _ppu_cur_name_table 
; 	LDA _ppuctrl 
; 	AND #%00000011
; 	ASL A 
; 	ASL A 
; 	CLC 
; 	ADC #$20
; 	TAX 
; 	LDA #0
; 	RTS 
; .endproc

; ;extern u16 __fastcall__ ppu_next_name_table_h();
; .export _ppu_next_name_table_h 

; .proc _ppu_next_name_table_h 
; 	LDA _ppuctrl 
; 	AND #%00000011
; 	EOR #%00000001
; 	ASL A 
; 	ASL A 
; 	CLC 
; 	ADC #$20
; 	TAX 
; 	LDA #0
; 	RTS 
; .endproc

; ;extern u16 __fastcall__ ppu_next_name_table_v();
; .export _ppu_next_name_table_v 

; .proc _ppu_next_name_table_v 
; 	LDA _ppuctrl 
; 	AND #%00000011
; 	EOR #%00000010
; 	ASL A 
; 	ASL A 
; 	CLC 
; 	ADC #$20
; 	TAX 
; 	LDA #0
; 	RTS 
; .endproc