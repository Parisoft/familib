    .importzp sp, oamtmp3 
    .export _oam_hide_sprites_range 

OAMBUFF = $0200
OAMADDR = $2003
OAMDATA = $2004
OAMDMA  = $4014

; void __fastcall__ oam_hide_sprites_range(u8 from, u8 to);
.proc _oam_hide_sprites_range 
    asl A 
    asl A 
    sta oamtmp3 ; tmp3 = to*4
    ldy #0
    lda (sp), y
    asl A 
    asl A 
    tax 
    lda #$F0
@hide:
    sta OAMBUFF, x
    .repeat 4
    inx 
    .endrepeat
    cpx oamtmp3 
    bne @hide
    lda sp+0 
	clc 
	adc #1
	sta sp+0 
	bcc @done
	inc sp+1 
@done:
    rts 
.endproc