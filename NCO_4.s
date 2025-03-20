#include <xc.inc>
	
global	Phase_Setup_4, IO_Setup_4, Lookup_Setup_4  ; global routines
global	Phase_Jump_4, Phase_Accum_4, Lookup_Ptr_4 ; global variables
extrn	Lookup_Table	; global data

psect	udata_acs   ; reserve data space in access ram
Phase_Jump_4:	ds  2
Phase_Accum_4:	ds  2
Lookup_Ptr_4:	ds  3

psect	nco_code_4, class=CODE

Phase_Setup_4:
	clrf	Phase_Accum_4 + 1,    A
	clrf	Phase_Accum_4,	    A
	clrf	Phase_Jump_4 + 1,	    A
	clrf	Phase_Jump_4,	    A
	movlw	0x3F
	movwf	Phase_Jump_4,	    A
	movlw	0x03
	movwf	Phase_Jump_4 + 1,	    A
	return

IO_Setup_4:
	clrf	TRISF,	A	; Set PORTF as all outputs
	clrf	LATF,	A	; Clear PORTF outputs
 	return

Lookup_Setup_4:
	bcf	CFGS			; point to Flash program memory  
	bsf	EEPGD			; access Flash program memory
Lookup_Init_4:
	movlw	low highword(Lookup_Table)	; address of data in PM
	movwf	Lookup_Ptr_4 + 2,    A		; load upper bits to TBLPTRU
	movlw	high(Lookup_Table)		; address of data in PM
	movwf	Lookup_Ptr_4 + 1,    A		; load high byte to TBLPTRH
	movlw	low(Lookup_Table)		; address of data in PM
	movwf	Lookup_Ptr_4,	   A		; load low byte to TBLPTRL
	return

	end
