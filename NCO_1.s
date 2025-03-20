#include <xc.inc>
	
global	Phase_Setup_1, IO_Setup_1, Lookup_Setup_1, NCO_Int_Hi_1  ; global routines
global	Phase_Jump_1, Phase_Accum_1, Lookup_Ptr_1 ; global variables
extrn	Lookup_Table	; global data

psect	udata_acs   ; reserve data space in access ram
Phase_Jump_1:	ds  2
Phase_Accum_1:	ds  2
Lookup_Ptr_1:	ds  3

psect	nco_code_1, class=CODE

Phase_Setup_1:
	clrf	Phase_Accum_1 + 1,    A
	clrf	Phase_Accum_1,	    A
	clrf	Phase_Jump_1 + 1,	    A
	clrf	Phase_Jump_1,	    A
	movlw	0xB8
	movwf	Phase_Jump_1,	    A
	movlw	0x01
	movwf	Phase_Jump_1 + 1,	    A
	return

IO_Setup_1:
	clrf	TRISJ,	A	; Set PORTD as all outputs
	clrf	LATJ,	A	; Clear PORTD outputs
 	return

Lookup_Setup_1:
	bcf	CFGS			; point to Flash program memory  
	bsf	EEPGD			; access Flash program memory
Lookup_Init_1:
	movlw	low highword(Lookup_Table)	; address of data in PM
	movwf	Lookup_Ptr_1 + 2,    A		; load upper bits to TBLPTRU
	movlw	high(Lookup_Table)		; address of data in PM
	movwf	Lookup_Ptr_1 + 1,    A		; load high byte to TBLPTRH
	movlw	low(Lookup_Table)		; address of data in PM
	movwf	Lookup_Ptr_1,	   A		; load low byte to TBLPTRL
	return

	end
