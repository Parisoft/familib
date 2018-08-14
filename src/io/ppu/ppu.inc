	.importzp sp 
	
PPUCTRL   = $2000
PPUSTATUS = $2002
PPUADDR   = $2006
PPUDATA   = $2007
SCREEN_ROWS = 30
SCREEN_COLS = 32

.macro pop_a 
	LDY #0
	LDA (sp), Y 
	INC sp 
	BNE :+ 
	INC sp+1 
:
.endmacro

.macro updsp n 
	CLC 
	LDA sp+0 
	ADC #n 
	STA sp+0 
	BCC :+ 
	INC sp+1
: 
.endmacro