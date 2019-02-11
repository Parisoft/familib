	.include "ppu.inc"
	
	.exportzp _ppu 

	.segment "ZEROPAGE"
_ppu:		.res .sizeof(ppu_t)
