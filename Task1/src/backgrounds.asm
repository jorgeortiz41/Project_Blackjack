.include "constants.inc"
.include "header.inc"

.segment "ZEROPAGE"
	pad1: .res 1  	;Controller 1 state
	bet: .res 1		;Current bet Amount
	previous_pad1: .res 1  ; Reserve space for previous pad state
	player_hi: .res 1
	player_lo: .res 1
	dealer_hi: .res 1
	dealer_lo: .res 1
	start_card_tile1: .res 1
	start_card_tile2: .res 1
	start_card_tile3: .res 1
	start_card_tile4: .res 1
	start_card_tile5: .res 1
	start_card_tile6: .res 1
	start_card_tile7: .res 1
	start_card_tile8: .res 1
	player_cards: .res 1
	dealer_cards: .res 1
.exportzp pad1, bet, previous_pad1, player_hi, player_lo, dealer_hi, dealer_lo, start_card_tile1, start_card_tile2, start_card_tile3, start_card_tile4, start_card_tile5, start_card_tile6, start_card_tile7, start_card_tile8, player_cards, dealer_cards

.segment "CODE"
.proc irq_handler
  RTI
.endproc

.import read_controller1, check_buttons, draw_card_dealer, draw_card_player

.proc nmi_handler
  	LDA #$00
  	STA OAMADDR
  	LDA #$02
  	STA OAMDMA
	LDA #$00

	;read controller
	JSR read_controller1

	; update tiles *after* DMA transfer
  	; and after reading controller state
	JSR check_buttons
	
	; Optional: Reset scroll only if necessary
	LDA #$00
	STA $2005   ; Set horizontal scroll to 0
	STA $2005   ; Set vertical scroll to 0
  RTI
.endproc

.import reset_handler

.export main
.proc main
	;Initialize bet to zero tile
	LDA #$52
	STA bet
	LDA #$22
	STA player_hi
	LDA #$45
	STA player_lo  
	LDA #$20
	STA dealer_hi
	LDA #$68
	STA dealer_lo
	LDA #$70
	STA start_card_tile1
	LDA #$71
	STA start_card_tile2
	LDA #$72
	STA start_card_tile3
	LDA #$73
	STA start_card_tile4
	LDA #$EC
	STA start_card_tile5
	LDA #$ED
	STA start_card_tile6
	LDA #$EE
	STA start_card_tile7
	LDA #$EF
	STA start_card_tile8
	LDA #$00
	STA player_cards
	LDA #$00
	STA dealer_cards
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

	JSR draw_all_cards
	JSR draw_deck

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

.proc draw_deck
	; Set dealer_lo to first slot in the deck	
	LDA #$65
	STA dealer_lo
	LDA #$20
	STA dealer_hi
	; Draw first tile of the deck
	LDX #$62
	LDA PPUSTATUS
	LDA dealer_hi
	STA PPUADDR
	LDA dealer_lo
	STA PPUADDR
	TXA
	STA PPUDATA

	; Set dealer_lo to second slot in the deck
	LDA #$66
	STA dealer_lo
	; Draw second tile of the deck
	LDX #$63
	LDA PPUSTATUS
	LDA dealer_hi
	STA PPUADDR
	LDA dealer_lo
	STA PPUADDR
	TXA
	STA PPUDATA

	; Set dealer_lo to third slot in the deck
	LDA #$85
	STA dealer_lo

	; Draw third tile of the deck
	LDX #$64
	LDA PPUSTATUS
	LDA dealer_hi
	STA PPUADDR
	LDA dealer_lo
	STA PPUADDR
	TXA
	STA PPUDATA

	; Set dealer_lo to fourth slot in the deck
	LDA #$86
	STA dealer_lo

	; Draw fourth tile of the deck
	LDX #$65
	LDA PPUSTATUS
	LDA dealer_hi
	STA PPUADDR
	LDA dealer_lo
	STA PPUADDR
	TXA
	STA PPUDATA

	; Set dealer_lo to fifth slot in the deck
	LDA #$A5
	STA dealer_lo

	; Draw fifth tile of the deck
	LDX #$64
	LDA PPUSTATUS
	LDA dealer_hi
	STA PPUADDR
	LDA dealer_lo
	STA PPUADDR
	TXA
	STA PPUDATA

	; Set dealer_lo to sixth slot in the deck
	LDA #$A6
	STA dealer_lo

	; Draw sixth tile of the deck
	LDX #$65
	LDA PPUSTATUS
	LDA dealer_hi
	STA PPUADDR
	LDA dealer_lo
	STA PPUADDR
	TXA
	STA PPUDATA

	; Set dealer_lo to seventh slot in the deck
	LDA #$C5
	STA dealer_lo

	; Draw seventh tile of the deck
	LDX #$66
	LDA PPUSTATUS
	LDA dealer_hi
	STA PPUADDR
	LDA dealer_lo
	STA PPUADDR
	TXA
	STA PPUDATA

	; Set dealer_lo to eighth slot in the deck
	LDA #$C6
	STA dealer_lo

	; Draw eighth tile of the deck
	LDX #$67
	LDA PPUSTATUS
	LDA dealer_hi
	STA PPUADDR
	LDA dealer_lo
	STA PPUADDR
	TXA
	STA PPUDATA

	LDA #$20
	STA dealer_hi
	LDA #$68
	STA dealer_lo

	;End
	RTS
.endproc

.proc draw_all_cards
	;Draw player cards
draw_player_cards:
	LDA player_cards
	CMP #$10
	BEQ draw_dealer_cards
	JSR draw_card_player
	JMP draw_player_cards
draw_dealer_cards:
	LDA	dealer_cards
	CMP #$0F
	BEQ end
	JSR draw_card_dealer
	JMP draw_dealer_cards
end:
	RTS
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
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
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
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
	.byte $02,$02,$02,$40,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
	.byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$41,$02,$02
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
