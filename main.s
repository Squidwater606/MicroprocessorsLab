#include <xc.inc>

extrn	Phase_Setup_1, IO_Setup_1, Lookup_Setup_1, DDS_Int_Hi_1

psect	code, abs
rst:	org	0x0000	; reset vector
	goto	Start

Int_Hi:	org	0x0008	; high vector, no low vector
	goto	DDS_Int_Hi_1
	
Start:	call	Timer_Setup
	call	Phase_Setup_1
	call	IO_Setup_1
	call	Lookup_Setup_1
	goto	$	; Sit in infinite loop

Timer_Setup:
	movlw	11001000B	; Set timer0 to 8-bit, Fosc/4
	movwf	T0CON,	A	; = 16MHz clock rate, approx 4ms rollover
	bsf	TMR0IE		; Enable timer0 interrupt
	bsf	GIE		; Enable all interrupts
	return

    end	    rst
