#include <xc.inc>
    
global  keyPad_Setup, keyPad_Read, keyPad_Display, delay, delay_count

psect	udata_acs   ; reserve data space in access ram
pos_read:   ds 1
pos_store:  ds 1
counter:    ds 1
delay_count:ds 1    ; reserve one byte for counter in the delay routine

psect	data
posValid:
    db	0x77, 0x7B, 0x7D, 0x7E, 0xB7, 0xBB, 0xBD, 0xBE
    db	0xD7, 0xDB, 0xDD, 0xDE, 0xE7, 0xEB, 0xED, 0xEE
    posValid_1 EQU 0x10
    align 2

keys:
    db	'C', 'B', '0', 'A', 'D', '9', '8', '7'
    db	'E', '6', '5', '4', 'F', '3', '2', '1'
    keys_1 EQU 0x10
    align 2

psect	keyPad_code,class=CODE
keyPad_Setup:
    movlb   0x0F	; select bank 15 (contains PADCFG1)
    bsf	    REPU	; turn on pull-ups
    movlb   0x00
    clrf    LATE, A	; 
    clrf    TRISD, A

posValid_Setup:
    lfsr	0, posValid	; Load FSR0 with address in RAM	
    movlw	low highword(posValid)	; address of data in PM
    movwf	TBLPTRU, A		; load upper bits to TBLPTRU
    movlw	high(posValid)	; address of data in PM
    movwf	TBLPTRH, A		; load high byte to TBLPTRH
    movlw	low(posValid)	; address of data in PM
    movwf	TBLPTRL, A		; load low byte to TBLPTRL
    movlw	posValid_1	; bytes to read
    movwf 	counter, A		; our counter register
loop1: 	
    tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
    movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
    decfsz	counter, A	; count down to zero
    bra		loop1		; keep going until finished
keys_Setup:
    lfsr	0, keys		; Load FSR1 with address in RAM	
    movlw	low highword(keys)	; address of data in PM
    movwf	TBLPTRU, A	; load upper bits to TBLPTRU
    movlw	high(keys)	; address of data in PM
    movwf	TBLPTRH, A	; load high byte to TBLPTRH
    movlw	low(keys)	; address of data in PM
    movwf	TBLPTRL, A	; load low byte to TBLPTRL
    movlw	keys_1		; bytes to read
    movwf 	counter, A	; our counter register
loop2: 	
    tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
    movff	TABLAT, POSTINC1; move data from TABLAT to (FSR1), inc FSR1	
    decfsz	counter, A	; count down to zero
    bra		loop2		; keep going until finished
    return

keyPad_Read:
    movlw   0x0F
    movwf   TRISE, A
    call    delay
    movff   PORTE, pos_read
    
    movlw   0xF0
    movwf   TRISE, A
    call    delay
    movf    PORTE, w, A
    
    iorwf   pos_read, A
    ;movff   pos_read, PORTD
    ;clrf    pos_read, A

loopDecode:
    cpfseq  POSTINC0, A
    bra	    loopDecode
    ; set true statement here, add another compare and implement loops as necessary
    movff   pos_read, pos_store

    return

keyPad_Display:
    movff   pos_store, PORTD
    return

delay:
    decfsz  delay_count, A	; decrement until zero
    bra	    delay
    return

    end