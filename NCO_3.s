#include <xc.inc>
	
global	Phase_Setup_3, IO_Setup_3, Lookup_Setup_3  ; global routines
global	Phase_Jump_3, Phase_Accum_3, Lookup_Ptr_3 ; global variables
extrn	Lookup_Table	; global data
extrn	Phase_Jump_3

psect	udata_acs   ; reserve data space in access ram
Phase_Accum_3:	ds  2
Lookup_Ptr_3:	ds  3

psect	nco_code_3, class=CODE

Phase_Setup_3:
	clrf	Phase_Accum_3 + 1,    A
	clrf	Phase_Accum_3,	    A
	clrf	Phase_Jump_3 + 1,	    A
	clrf	Phase_Jump_3,	    A
	;movlw	0x93
	;movwf	Phase_Jump_3,	    A
	;movlw	0x02
	;movwf	Phase_Jump_3 + 1,	    A
	return

IO_Setup_3:
	clrf	TRISE,	A	; Set PORTE as all outputs
	clrf	LATE,	A	; Clear PORTE outputs
 	return

Lookup_Setup_3:
	bcf	CFGS			; point to Flash program memory  
	bsf	EEPGD			; access Flash program memory
Lookup_Init_3:
	movlw	low highword(Lookup_Table)	; address of data in PM
	movwf	Lookup_Ptr_3 + 2,    A		; load upper bits to TBLPTRU
	movlw	high(Lookup_Table)		; address of data in PM
	movwf	Lookup_Ptr_3 + 1,    A		; load high byte to TBLPTRH
	movlw	low(Lookup_Table)		; address of data in PM
	movwf	Lookup_Ptr_3,	   A		; load low byte to TBLPTRL
	return

	end
