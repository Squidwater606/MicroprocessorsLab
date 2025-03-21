#include <xc.inc>
	
global	Phase_Setup_2, IO_Setup_2, Lookup_Setup_2  ; global routines
global	Phase_Jump_2, Phase_Accum_2, Lookup_Ptr_2 ; global variables
extrn	Lookup_Table	; global data
extrn	Phase_Jump_2

psect	udata_acs   ; reserve data space in access ram
Phase_Accum_2:	ds  2
Lookup_Ptr_2:	ds  3

psect	nco_code_2, class=CODE

Phase_Setup_2:
	clrf	Phase_Accum_2 + 1,    A
	clrf	Phase_Accum_2,	    A
	clrf	Phase_Jump_2 + 1,	    A
	clrf	Phase_Jump_2,	    A
	movlw	0x2A
	movwf	Phase_Jump_2,	    A
	movlw	0x02
	movwf	Phase_Jump_2 + 1,	    A
	return

IO_Setup_2:
	clrf	TRISH,	A	; Set PORTH as all outputs
	clrf	LATH,	A	; Clear PORTH outputs
 	return

Lookup_Setup_2:
	bcf	CFGS			; point to Flash program memory  
	bsf	EEPGD			; access Flash program memory
Lookup_Init_2:
	movlw	low highword(Lookup_Table)	; address of data in PM
	movwf	Lookup_Ptr_2 + 2,    A		; load upper bits to TBLPTRU
	movlw	high(Lookup_Table)		; address of data in PM
	movwf	Lookup_Ptr_2 + 1,    A		; load high byte to TBLPTRH
	movlw	low(Lookup_Table)		; address of data in PM
	movwf	Lookup_Ptr_2,	   A		; load low byte to TBLPTRL
	return

	end
