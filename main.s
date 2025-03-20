#include <xc.inc>

extrn	Phase_Setup_1, IO_Setup_1, Lookup_Setup_1
extrn	Phase_Setup_2, IO_Setup_2, Lookup_Setup_2
extrn	Phase_Setup_3, IO_Setup_3, Lookup_Setup_3
extrn	Phase_Setup_4, IO_Setup_4, Lookup_Setup_4
extrn	NCO_Int_Hi

psect	code, abs
rst:	org	0x0000	; reset vector
	goto	Start

Int_Hi:	org	0x0008	; high vector, no low vector
	goto	NCO_Int_Hi
	
Start:	call	Timer_Setup
	call	Phase_Setup_1
 	call	Phase_Setup_2
  	call	Phase_Setup_3
   	call	Phase_Setup_4
	call	IO_Setup_1
 	call	IO_Setup_2
  	call	IO_Setup_3
   	call	IO_Setup_4
	call	Lookup_Setup_1
 	call	Lookup_Setup_2
	call	Lookup_Setup_3
 	call	Lookup_Setup_4
	goto	$	; Sit in infinite loop

Timer_Setup:
	movlw	11001000B	; Set timer0 to 8-bit, Fosc/4
	movwf	T0CON,	A	; = 16MHz clock rate, approx 4ms rollover
	bsf	TMR0IE		; Enable timer0 interrupt
	bsf	GIE		; Enable all interrupts
	return

    end	    rst
