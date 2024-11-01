.include "constants.inc"
.include "header.inc"

.segment "CODE"
.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  	LDA #$00
  	STA OAMADDR
  	LDA #$02
  	STA OAMDMA
	LDA #$00
	
	; Optional: Reset scroll only if necessary
	LDA #$00
	STA $2005   ; Set horizontal scroll to 0
	STA $2005   ; Set vertical scroll to 0
  RTI
.endproc

.import reset_handler

.export main
.proc main
  ; write a palette
  LDX PPUSTATUS
  LDX #$3f
  STX PPUADDR
  LDX #$00
  STX PPUADDR
load_palettes:
  LDA palettes,X
  STA PPUDATA
  INX
  CPX #$20
  BNE load_palettes

  ; write sprite data
  LDX #$00
load_sprites:
  LDA sprites,X
  STA $0200,X
  INX
  CPX #$10
  BNE load_sprites

	; write nametables
loadb:
	lda PPUSTATUS
	lda #$20
	sta PPUADDR
	lda #$00
	sta PPUADDR

	ldx #$00
backloop:
	lda back, X
	sta PPUDATA 
	inx 
	cpx #$ff
	bne backloop

backloop2:
	lda back + 256, X
	sta PPUDATA 
	inx 
	cpx #$ff
	bne backloop2

backloop3:
	lda back + 512, X
	sta PPUDATA 
	inx 
	cpx #$ff
	bne backloop3

backloop4:
	lda back + 768, X
	sta PPUDATA 
	inx 
	cpx #$c0
	bne backloop4

	; Controller initialization (strobe)
	LDA #%00000001      ; set bit 0 to 1 to strobe
	STA $4016           ; write to $4016 to strobe controller
	LDA #%00000000      ; set bit 0 to 0 to end strobe
	STA $4016

vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%10010000  ; turn on NMIs, sprites use first pattern table
  STA PPUCTRL
  LDA #%00001110  ; turn on screen
  STA PPUMASK

forever:
  JMP forever
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "RODATA"
buttons: .byte 0    ; Holds the current controller button state
button_count: .byte 0 ; Counter for button polling
back:
	.byte $02,$02,$02,$02,$13,$06,$3f,$21,$1e,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30
	.byte $30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$02,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$62,$63,$02,$70,$71,$02,$74,$75,$02,$78,$79
	.byte $02,$84,$85,$02,$88,$89,$02,$94,$95,$02,$d4,$d5,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$64,$65,$02,$72,$73,$02,$76,$77,$02,$7a,$7b
	.byte $02,$86,$87,$02,$8a,$8b,$02,$96,$97,$02,$d6,$d7,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$64,$65,$02,$e8,$e9,$02,$e0,$e1,$02,$ec,$ed
	.byte $02,$e4,$e5,$02,$e8,$e9,$02,$e0,$e1,$02,$e0,$e1,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$66,$67,$02,$ea,$eb,$02,$e2,$e3,$02,$ee,$ef
	.byte $02,$e6,$e7,$02,$ea,$eb,$02,$e2,$e3,$02,$e2,$e3,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$98,$99,$02,$a4,$a5,$02,$a8,$a9,$02,$b4,$b5
	.byte $02,$b8,$b9,$02,$c4,$c5,$02,$c8,$c9,$02,$d4,$d5,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$9a,$9b,$02,$a6,$a7,$02,$aa,$ab,$02,$b6,$b7
	.byte $02,$ba,$bb,$02,$c6,$c7,$02,$ca,$cb,$02,$d6,$d7,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$e8,$e9,$02,$e4,$e5,$02,$ec,$ed,$02,$e0,$e1
	.byte $02,$e8,$e9,$02,$e4,$e5,$02,$ec,$ed,$02,$e0,$e1,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$ea,$eb,$02,$e6,$e7,$02,$ee,$ef,$02,$e2,$e3
	.byte $02,$ea,$eb,$02,$e6,$e7,$02,$ee,$ef,$02,$e2,$e3,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$02,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50
	.byte $50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$02,$02,$02
	.byte $02,$02,$02,$02,$13,$0f,$04,$1c,$08,$15,$3f,$1f,$1e,$02,$02,$02
	.byte $02,$02,$06,$04,$16,$0b,$3f,$53,$52,$52,$52,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$05,$0c,$07,$02,$3f,$52,$52,$21,$23,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30
	.byte $30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$02,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$d4,$d5,$02,$d4,$d5,$02,$d4,$d5,$02,$d4,$d5
	.byte $02,$d4,$d5,$02,$d4,$d5,$02,$d4,$d5,$02,$d4,$d5,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$d6,$d7,$02,$d6,$d7,$02,$d6,$d7,$02,$d6,$d7
	.byte $02,$d6,$d7,$02,$d6,$d7,$02,$d6,$d7,$02,$d6,$d7,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$e0,$e1,$02,$e0,$e1,$02,$e0,$e1,$02,$e0,$e1
	.byte $02,$e0,$e1,$02,$e0,$e1,$02,$e0,$e1,$02,$e0,$e1,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$e2,$e3,$02,$e2,$e3,$02,$e2,$e3,$02,$e2,$e3
	.byte $02,$e2,$e3,$02,$e2,$e3,$02,$e2,$e3,$02,$e2,$e3,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$d4,$d5,$02,$d4,$d5,$02,$d4,$d5,$02,$d4,$d5
	.byte $02,$d4,$d5,$02,$d4,$d5,$02,$d4,$d5,$02,$d4,$d5,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$d6,$d7,$02,$d6,$d7,$02,$d6,$d7,$02,$d6,$d7
	.byte $02,$d6,$d7,$02,$d6,$d7,$02,$d6,$d7,$02,$d6,$d7,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$e0,$e1,$02,$e0,$e1,$02,$e0,$e1,$02,$e0,$e1
	.byte $02,$e0,$e1,$02,$e0,$e1,$02,$e0,$e1,$02,$e0,$e1,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$e2,$e3,$02,$e2,$e3,$02,$e2,$e3,$02,$e2,$e3
	.byte $02,$e2,$e3,$02,$e2,$e3,$02,$e2,$e3,$02,$e2,$e3,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$02,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50
	.byte $50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$50,$02,$02,$02
	.byte $06,$15,$0c,$16,$17,$0c,$04,$11,$02,$05,$04,$15,$15,$08,$15,$04
	.byte $16,$40,$02,$0d,$12,$15,$0a,$08,$02,$12,$15,$17,$0c,$1d,$02,$02
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f

palettes:
.byte $0f, $30, $1a, $16
.byte $0f, $2b, $3c, $39
.byte $0f, $0c, $07, $13
.byte $0f, $19, $09, $29

.byte $0f, $2d, $10, $15
.byte $0f, $19, $09, $29
.byte $0f, $19, $09, $29
.byte $0f, $19, $09, $29

sprites:
.byte $70, $05, $00, $80
.byte $70, $06, $00, $88
.byte $78, $07, $00, $80
.byte $78, $06, $00, $88

.segment "CHR"
.incbin "tiles.chr"
