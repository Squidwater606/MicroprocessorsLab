#include <xc.inc>
	
global	Phase_Setup_2, IO_Setup_2, Lookup_Setup_2, NCO_Int_Hi_2  ; global routines
extrn	Lookup_Table	; global data

psect	udata_acs   ; reserve data space in access ram
Phase_Jump_2:	ds  2
Phase_Accum_2:	ds  2
Lookup_Ptr_2:	ds  3

psect	nco_code_2, class=CODE

Phase_Setup_2:
	clrf	Phase_Accum_2 + 1,    A
	clrf	Phase_Accum_2,	    A
	clrf	Phase_Jump_2 + 1,	    A
	clrf	Phase_Jump_2,	    A
	movlw	0xB8
	movwf	Phase_Jump_2,	    A
	movlw	0x01
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

NCO_Int_Hi_2:	
	btfss	TMR0IF		; check that this is timer0 interrupt
	retfie	f		; if not then return
Pointer_Ld_2:
	movf	Lookup_Ptr_2 + 2, W, A
	movwf	TBLPTRU,	   A
	movf	Lookup_Ptr_2 + 1, W, A
	movwf	TBLPTRH,	   A
	movf	Lookup_Ptr_2,	W, A
	movwf	TBLPTRL,	   A
Phase_Amp_2:
	tblrd*
	movff	TABLAT, LATH
Re_Init_2:
	movlw	low highword(Lookup_Table)	; address of data in PM
	movwf	Lookup_Ptr_2 + 2,    A		; load upper bits to TBLPTRU
	movlw	high(Lookup_Table)		; address of data in PM
	movwf	Lookup_Ptr_2 + 1,    A		; load high byte to TBLPTRH
	movlw	low(Lookup_Table)		; address of data in PM
	movwf	Lookup_Ptr_2,	   A		; load low byte to TBLPTRL
Phase_Inc_2:
	movf	Phase_Jump_2, W,	A
	addwf	Phase_Accum_2,	A
	movf	Phase_Jump_2 + 1,	W,  A
	addwfc	Phase_Accum_2 + 1,    A
Pointer_Inc_2:
	movf	Phase_Accum_2,	W,  A
	addwf	Lookup_Ptr_2,	A
	movf	Phase_Accum_2 + 1,	W,  A
	addwfc	Lookup_Ptr_2 + 1,	A
	movlw	0x00
	addwfc	Lookup_Ptr_2 + 2,	A
	bcf	TMR0IF		; clear interrupt flag
	retfie	f		; fast return from interrupt

	end
