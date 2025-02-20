#include <xc.inc>
    
global  keyPad_Setup, keyPad_Read

psect	keyPad_code,class=CODE
keyPad_Setup:
    movlb   0x0F	; select bank 15 (contains PADCFG1)
    bsf	    REPU	; turn on pull-ups
    clrf    LATE	; 
    clrf    TRISD
    clrf    TRISF

    return

keyPad_Read:	; Add Delay
    movlw   0x0F
    movwf   TRISE
    movff   PORTE,  PORTD
    movlw   0xF0
    movwf   TRISE
    movff   PORTE,  PORTF

    return
