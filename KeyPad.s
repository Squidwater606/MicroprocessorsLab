#include <xc.inc>
    
global  keyPad_Setup, keyPad_Read, delay, delay_count

psect	udata_acs   ; reserve data space in access ram
column_pos: ds 1
row_pos:    ds 1
full_pos:   ds 1
pos:	    ds 1
delay_count:ds 1    ; reserve one byte for counter in the delay routine
    
psect	keyPad_code,class=CODE
keyPad_Setup:
    movlb   0x0F	; select bank 15 (contains PADCFG1)
    bsf	    REPU	; turn on pull-ups
    movlb   0x00
    clrf    LATE, A	; 
    clrf    TRISD, A
    ;clrf    TRISF, A
    ;clrf    TRISH, A
    return

keyPad_Read:
    movlw   0x0F
    movwf   TRISE, A
    call    delay
    movff   PORTE, column_pos
    call    delay
    
    movlw   0xF0
    movwf   TRISE, A
    call    delay
    movff   PORTE, row_pos
    call    delay

    ;movff   column_pos, PORTD
    ;call    delay
    ;movff   row_pos, PORTF
    ;call    delay

    movf    column_pos,	w, A
    addwf   pos, f, A
    movf    row_pos, w, A
    addwf   pos, f, A

    call    delay
    movff   pos, PORTD
    clrf    pos, A
    
    return

delay:
    decfsz  delay_count, A	; decrement until zero
    bra	    delay
    return

    end