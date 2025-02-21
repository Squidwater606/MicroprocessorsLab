#include <xc.inc>
    
global  keyPad_Setup, keyPad_Read, delay, delay_count

psect	udata_acs   ; reserve data space in access ram
pos:	    ds 1
delay_count:ds 1    ; reserve one byte for counter in the delay routine
    
psect	keyPad_code,class=CODE
keyPad_Setup:
    movlb   0x0F	; select bank 15 (contains PADCFG1)
    bsf	    REPU	; turn on pull-ups
    movlb   0x00
    clrf    LATE, A	; 
    clrf    TRISD, A
    return

keyPad_Read:
    movlw   0x0F
    movwf   TRISE, A
    call    delay
    movff   PORTE, pos
    
    movlw   0xF0
    movwf   TRISE, A
    call    delay
    movf    PORTE, w, A
    
    iorwf   pos
    movff   pos, PORTD
    clrf    pos, A
    
    return

delay:
    decfsz  delay_count, A	; decrement until zero
    bra	    delay
    return

    end