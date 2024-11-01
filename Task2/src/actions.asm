.include "constants.inc"

.segment "ZEROPAGE"
.importzp pad1, bet, bet_score1,bet_score2,bet_score3, previous_pad1, player_hi, player_lo, dealer_hi, dealer_lo, start_card_tile1, start_card_tile2, start_card_tile3, start_card_tile4, start_card_tile5, start_card_tile6, start_card_tile7, start_card_tile8, player_cards, dealer_cards

.segment "CODE"
.proc loadcard
	LDX #$A0
  LDA PPUSTATUS
  LDA #$20
  STA PPUADDR
  LDA #$65
  STA PPUADDR
  TXA
  STA PPUDATA
  LDX #$A1
  LDA PPUSTATUS
  LDA #$20
  STA PPUADDR
  LDA #$66
  STA PPUADDR
  TXA
  STA PPUDATA
  RTS
.endproc

.export draw_card_dealer
.proc draw_card_dealer
    ; Check if dealer_cards is equal to 0x0B
    LDA dealer_cards
    CMP #$0B
    ; If is equal to 0x0B, end procedure
    BEQ end_bridge

    ; Logic to draw the a card for the player in sequence
    LDX start_card_tile1
    LDA PPUSTATUS
    LDA dealer_hi
    STA PPUADDR
    LDA dealer_lo
    STA PPUADDR
    TXA
    STA PPUDATA

    LDX start_card_tile2
    ;increase dealer_lo by 0x01
    LDA dealer_lo
    CLC
    ADC #$01
    STA dealer_lo

    LDA PPUSTATUS
    LDA dealer_hi
    STA PPUADDR
    LDA dealer_lo
    STA PPUADDR
    TXA
    STA PPUDATA

    LDX start_card_tile3
    ;increase dealer_lo by 0x1F
    LDA dealer_lo
    CLC
    ADC #$1F
    STA dealer_lo

    LDA PPUSTATUS
    LDA dealer_hi
    STA PPUADDR
    LDA dealer_lo
    STA PPUADDR
    TXA
    STA PPUDATA

    LDX start_card_tile4
    ;increase dealer_lo by 0x01
    LDA dealer_lo
    CLC
    ADC #$01
    STA dealer_lo

    LDA PPUSTATUS
    LDA dealer_hi
    STA PPUADDR
    LDA dealer_lo
    STA PPUADDR
    TXA
    STA PPUDATA

    LDX start_card_tile5
    ;increase dealer_lo by 0x1F
    LDA dealer_lo
    CLC
    ADC #$1F
    STA dealer_lo

end_bridge:
    LDA dealer_cards
    CMP #$0B
    ; If is equal to 0x0B, end procedure
    BEQ end

    LDA PPUSTATUS
    LDA dealer_hi
    STA PPUADDR
    LDA dealer_lo
    STA PPUADDR
    TXA
    STA PPUDATA

    LDX start_card_tile6
    ;increase dealer_lo by 0x01
    LDA dealer_lo
    CLC
    ADC #$01
    STA dealer_lo
    
    LDA PPUSTATUS
    LDA dealer_hi
    STA PPUADDR
    LDA dealer_lo
    STA PPUADDR
    TXA
    STA PPUDATA

    LDX start_card_tile7
    ;increase dealer_lo by 0x1F
    LDA dealer_lo
    CLC
    ADC #$1F
    STA dealer_lo

    LDA PPUSTATUS
    LDA dealer_hi
    STA PPUADDR
    LDA dealer_lo
    STA PPUADDR
    TXA
    STA PPUDATA

    LDX start_card_tile8
    ;increase dealer_lo by 0x01
    LDA dealer_lo
    CLC
    ADC #$01
    STA dealer_lo

    LDA PPUSTATUS
    LDA dealer_hi
    STA PPUADDR
    LDA dealer_lo
    STA PPUADDR
    TXA
    STA PPUDATA

    ;increase dealer_cards by 0x01
    LDA dealer_cards
    CLC
    ADC #$01
    STA dealer_cards
    ; Check if dealer_cards is equal to 0x08
    CMP #$07
    ; If is equal to 0x08, call update_card_position
    BEQ update_card_position
    ; If is not equal calculate next card position by subtracting 0x5E to dealer_lo
    LDA dealer_lo
    SEC
    SBC #$5E
    STA dealer_lo
    JMP end

update_card_position:
    ;Set dealer_hi to 0x21
    LDA #$21
    STA dealer_hi
    ;Set dealer_lo to 0x05
    LDA #$05
    STA dealer_lo
    RTS

end:
    LDA #$00
    LDX #$00
    RTS
.endproc

.export draw_card_player
.proc draw_card_player
    ; Check if player_cards is equal to 0x0B
    LDA player_cards
    CMP #$0B
    ; If is equal to 0x0B, end procedure
    BEQ end_bridge

    ; Logic to draw the a card for the player in sequence
    LDX start_card_tile1
    LDA PPUSTATUS
    LDA player_hi
    STA PPUADDR
    LDA player_lo
    STA PPUADDR
    TXA
    STA PPUDATA

    LDX start_card_tile2
    ;increase player_lo by 0x01
    LDA player_lo
    CLC
    ADC #$01
    STA player_lo

    LDA PPUSTATUS
    LDA player_hi
    STA PPUADDR
    LDA player_lo
    STA PPUADDR
    TXA
    STA PPUDATA

    LDX start_card_tile3
    ;increase player_lo by 0x1F
    LDA player_lo
    CLC
    ADC #$1F
    STA player_lo

    LDA PPUSTATUS
    LDA player_hi
    STA PPUADDR
    LDA player_lo
    STA PPUADDR
    TXA
    STA PPUDATA

    LDX start_card_tile4
    ;increase player_lo by 0x01
    LDA player_lo
    CLC
    ADC #$01
    STA player_lo

    LDA PPUSTATUS
    LDA player_hi
    STA PPUADDR
    LDA player_lo
    STA PPUADDR
    TXA
    STA PPUDATA

    LDX start_card_tile5
    ;increase player_lo by 0x1F
    LDA player_lo
    CLC
    ADC #$1F
    STA player_lo

end_bridge:
    LDA player_cards
    CMP #$0B
    ; If is equal to 0x0B, end procedure
    BEQ end

    LDA PPUSTATUS
    LDA player_hi
    STA PPUADDR
    LDA player_lo
    STA PPUADDR
    TXA
    STA PPUDATA

    LDX start_card_tile6
    ;increase player_lo by 0x01
    LDA player_lo
    CLC
    ADC #$01
    STA player_lo
    
    LDA PPUSTATUS
    LDA player_hi
    STA PPUADDR
    LDA player_lo
    STA PPUADDR
    TXA
    STA PPUDATA

    LDX start_card_tile7
    ;increase player_lo by 0x1F
    LDA player_lo
    CLC
    ADC #$1F
    STA player_lo

    LDA PPUSTATUS
    LDA player_hi
    STA PPUADDR
    LDA player_lo
    STA PPUADDR
    TXA
    STA PPUDATA

    LDX start_card_tile8
    ;increase player_lo by 0x01
    LDA player_lo
    CLC
    ADC #$01
    STA player_lo

    LDA PPUSTATUS
    LDA player_hi
    STA PPUADDR
    LDA player_lo
    STA PPUADDR
    TXA
    STA PPUDATA

    ;increase player_cards by 0x01
    LDA player_cards
    CLC
    ADC #$01
    STA player_cards
    ; Check if player_cards is equal to 0x08
    CMP #$08
    ; If is equal to 0x08, call update_card_position
    BEQ update_card_position
    ; If is not equal calculate next card position by subtracting 0x5E to player_lo
    LDA player_lo
    SEC
    SBC #$5E
    STA player_lo
    JMP end

update_card_position:
    ;Set player_hi to 0x21
    LDA #$23
    STA player_hi
    ;Set player_lo to 0x05
    LDA #$05
    STA player_lo
    RTS

end:
    LDA #$00
    LDX #$00
    RTS
.endproc

.export reset_table
.proc reset_table
  ; Logic to clear all drawn cards and reset the display
  RTS
.endproc

.export increase_bet
.proc increase_bet
  lda bet_score1
  CMP #$23             
  beq cap_bet
  lda #$23
  sta bet_score1
  JSR draw_bet_tile		; Draws the updated bet tile
  rts
cap_bet:
  lda #$1e
  sta bet_score1


;bet score_2
  lda bet_score2
  CMP #$27             
  beq cap_bet2
  inc bet_score2
  lda bet_score2
  sta bet_score2
  JSR draw_bet_tile		; Draws the updated bet tile
  rts
cap_bet2:

;bet score_3
  lda #$1e
  sta bet_score2
  lda bet_score3
  CMP #$27             
  beq cap_bet3
  inc bet_score3
  lda bet_score3
  sta bet_score3
  JSR draw_bet_tile		; Draws the updated bet tile
  rts
  cap_bet3:
  lda #$27
  sta bet_score3
  sta bet_score2
  lda #$23
  sta bet_score1
  jsr draw_bet_tile
  RTS
.endproc

.export decrease_bet
.proc decrease_bet
  lda bet_score1
  CMP #$1e             
  beq cap_bet
  lda #$1e
  sta bet_score1
  JSR draw_bet_tile		; Draws the updated bet tile
  rts
cap_bet:

;bet score_2
  lda bet_score2
  CMP #$1e             
  beq cap_bet2
  dec bet_score2
  lda bet_score2
  sta bet_score2
  lda #$23
  sta bet_score1
  JSR draw_bet_tile		; Draws the updated bet tile
  rts
cap_bet2:

;bet score_3

  lda bet_score3
  CMP #$1E             
  beq cap_bet3
  DEC bet_score3
  lda #$27
  sta bet_score2
  JSR draw_bet_tile		; Draws the updated bet tile
  rts
  cap_bet3:
  jsr draw_bet_tile
  RTS
.endproc

.proc draw_bet_tile
  LDX bet_score1				             
  ; Set PPU address to the position where the bet tile should be displayed
  LDA PPUSTATUS         ; Read PPU status to reset the latch
  LDA #$21
  STA PPUADDR           ; Set high byte of PPU address
  LDA #$fa              ; Set low byte of PPU address (example position)
  STA PPUADDR
  TXA
  STA PPUDATA           ; Store tile to PPU data

;draw bet_score2
  LDX bet_score2				             
  ; Set PPU address to the position where the bet tile should be displayed
  LDA PPUSTATUS         ; Read PPU status to reset the latch
  LDA #$21
  STA PPUADDR           ; Set high byte of PPU address
  LDA #$f9              ; Set low byte of PPU address (example position)
  STA PPUADDR
  TXA
  STA PPUDATA           ; Store tile to PPU data

;draw bet_score3
  LDX bet_score3				             
  ; Set PPU address to the position where the bet tile should be displayed
  LDA PPUSTATUS         ; Read PPU status to reset the latch
  LDA #$21
  STA PPUADDR           ; Set high byte of PPU address
  LDA #$f8              ; Set low byte of PPU address (example position)
  STA PPUADDR
  TXA
  STA PPUDATA           ; Store tile to PPU data
  RTS
.endproc

.proc draw_cash_tile
  LDX #$00
  ; Set PPU address to the position where the cash tile should be displayed
  LDA PPUSTATUS         ; Read PPU status to reset the latch
  LDA #$21
  STA PPUADDR           ; Set high byte of PPU address
  LDA #$D7              ; Set low byte of PPU address (example position)
  STA PPUADDR
  TXA
  STA PPUDATA           ; Store tile to PPU data
  RTS
.endproc