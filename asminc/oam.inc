    .importzp sp
    .globalzp oamptr
    .globalzp oamtmp1
    .globalzp oamtmp2
    .globalzp oamtmp3
    .global oam_set_sp;(u8_t x, u8_t y, u8_t sp, u8_t fx, u8_t num);
    .global oam_set_metasp;(u8_t x, u8_t y, u8_t num, const u8_t *meta);
    .global oam_set_metasp_fx;(u8_t x, u8_t y, u8_t fx, u8_t num, const u8_t *meta);
    .global oam_hide_sp;(u8_t num);
    .global oam_hide_sp_from;(u8_t num);
    .global oam_hide_sp_range;(u8_t from, u8_t to);
    ; For C code
    .global _oam_set_sp
    .global _oam_set_metasp
    .global _oam_set_metasp_fx
    .global _oam_hide_sp
    .global _oam_hide_sp_from
    .global _oam_hide_sp_range

    ; OAM buffer address
    .define OAMBUFF $0200

    ; OAM y position offset
    .define OAM_Y_OFF $0200

    ; OAM x position offset
    .define OAM_X_OFF $0203

    ; OAM fx offset
    .define OAM_FX_OFF $0202

    ; OAM id  offset
    .define OAM_ID_OFF $0201

    ; OAMADDR register
    .define OAMADDR $2003

    ; OAMDATA register
    .define OAMDATA $2004

    ; OAMDMA register
    .define OAMDMA $4014

    ; flush buffered sprites through DMA
    .macro oam_dma
    lda #<OAMBUFF
    sta OAMADDR
    lda #>OAMBUFF
    sta OAMDMA
    .endmac