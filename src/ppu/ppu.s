	.exportzp _ppu 

	.segment "ZEROPAGE"
_ppu:		.res 5	; 0:ctrl, 1:mask, 2:scrollX, 3:scrollY, 4:system
