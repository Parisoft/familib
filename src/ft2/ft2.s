    .include "ft2.inc"

	.segment "ZEROPAGE"

ft2zp:	.res 3

	.segment "BSS"
	.align $100, 0

ft2bss:	.res $8c ;FT_BASE_SIZE 
