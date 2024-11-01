.include "constants.inc"

.segment "ZEROPAGE"
.importzp pad1, previous_pad1

.segment "CODE"
.export read_controller1
.proc read_controller1
  PHA
  TXA
  PHA
  PHP

  ; write a 1, then a 0, to CONTROLLER1
  ; to latch button states
  LDA #$01
  STA CONTROLLER1
  LDA #$00
  STA CONTROLLER1

  LDA #%00000001
  STA pad1

get_buttons:
  LDA CONTROLLER1 ; Read next button's state
  LSR A           ; Shift button state right, into carry flag
  ROL pad1        ; Rotate button state from carry flag
                  ; onto right side of pad1
                  ; and leftmost 0 of pad1 into carry flag
  BCC get_buttons ; Continue until original "1" is in carry flag

  PLP
  PLA
  TAX
  PLA
  RTS
.endproc

.import draw_card_player, draw_card_dealer, reset_table, increase_bet, decrease_bet

.export check_buttons
.proc check_buttons
  ; Check if LEFT button was released
  LDA previous_pad1
  AND #BTN_LEFT           ; Check if LEFT was previously pressed
  BEQ check_right         ; If not, skip
  LDA pad1
  AND #BTN_LEFT           ; Check if LEFT is currently pressed
  BNE check_right         ; If it is still pressed, skip
  ; LEFT button was released, handle it here
  JSR decrease_bet    
  check_right:
    LDA previous_pad1
    AND #BTN_RIGHT          ; Check if RIGHT was previously pressed
    BEQ check_up            ; If not, skip
    LDA pad1
    AND #BTN_RIGHT          ; Check if RIGHT is currently pressed
    BNE check_up            ; If it is still pressed, skip
    ; RIGHT button was released, handle it here
    JSR increase_bet    ; Change Action PLZ
  check_up:
    ; Check if UP button was released
    LDA previous_pad1
    AND #BTN_UP             ; Check if UP was previously pressed
    BEQ check_down          ; If not, skip
    LDA pad1
    AND #BTN_UP             ; Check if UP is currently pressed
    BNE check_down          ; If it is still pressed, skip
    ; UP button was released, handle it here
    JSR increase_bet        ; Call increase bet when UP is released
  check_down:
    ; Check if DOWN button was released
    LDA previous_pad1
    AND #BTN_DOWN           ; Check if DOWN was previously pressed
    BEQ check_start         ; If not, skip
    LDA pad1
    AND #BTN_DOWN           ; Check if DOWN is currently pressed
    BNE check_start         ; If it is still pressed, skip
    ; DOWN button was released, handle it here
    JSR decrease_bet        ; Call decrease bet when DOWN is released
  check_start:
    ; Check if START button was released
    LDA previous_pad1
    AND #BTN_START          ; Check if START was previously pressed
    BEQ check_select        ; If not, skip
    LDA pad1
    AND #BTN_START          ; Check if START is currently pressed
    BNE check_select        ; If it is still pressed, skip
    ; START button was released, handle it here
    JSR reset_table
  check_select:
    ; Check if SELECT button was released
    LDA previous_pad1
    AND #BTN_SELECT         ; Check if SELECT was previously pressed
    BEQ check_b             ; If not, skip
    LDA pad1
    AND #BTN_SELECT         ; Check if SELECT is currently pressed
    BNE check_b             ; If it is still pressed, skip
    ; SELECT button was released, handle it here
    JSR reset_table
  check_b:
    ; Check if B button was released
    LDA previous_pad1
    AND #BTN_B              ; Check if B was previously pressed
    BEQ check_a             ; If not, skip
    LDA pad1
    AND #BTN_B              ; Check if B is currently pressed
    BNE check_a             ; If it is still pressed, skip
    ; B button was released, handle it here
    JSR draw_card_player
  check_a:
    ; Check if A button was released
    LDA previous_pad1
    AND #BTN_A              ; Check if A was previously pressed
    BEQ end_check_buttons   ; If not, skip
    LDA pad1
    AND #BTN_A              ; Check if A is currently pressed
    BNE end_check_buttons   ; If it is still pressed, skip
    ; A button was released, handle it here
    JSR draw_card_dealer
  end_check_buttons:
  ; Update previous_pad1 to current state for the next check
  LDA pad1
  STA previous_pad1
  RTS
.endproc