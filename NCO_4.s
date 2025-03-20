#include <xc.inc>
	
global	Phase_Setup_4, IO_Setup_4, Lookup_Setup_4, NCO_Int_Hi_4  ; global routines
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
	movlw	0xB8
	movwf	Phase_Jump_4,	    A
	movlw	0x01
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

NCO_Int_Hi_4:	
	btfss	TMR0IF		; check that this is timer0 interrupt
	retfie	f		; if not then return
Pointer_Ld_4:
	movf	Lookup_Ptr_4 + 2, W, A
	movwf	TBLPTRU,	   A
	movf	Lookup_Ptr_4 + 1, W, A
	movwf	TBLPTRH,	   A
	movf	Lookup_Ptr_4,	W, A
	movwf	TBLPTRL,	   A
Phase_Amp_4:
	tblrd*
	movff	TABLAT, LATH
Re_Init_4:
	movlw	low highword(Lookup_Table)	; address of data in PM
	movwf	Lookup_Ptr_4 + 2,    A		; load upper bits to TBLPTRU
	movlw	high(Lookup_Table)		; address of data in PM
	movwf	Lookup_Ptr_4 + 1,    A		; load high byte to TBLPTRH
	movlw	low(Lookup_Table)		; address of data in PM
	movwf	Lookup_Ptr_4,	   A		; load low byte to TBLPTRL
Phase_Inc_4:
	movf	Phase_Jump_4, W,	A
	addwf	Phase_Accum_4,	A
	movf	Phase_Jump_4 + 1,	W,  A
	addwfc	Phase_Accum_1 + 1,    A
Pointer_Inc_4:
	movf	Phase_Accum_4,	W,  A
	addwf	Lookup_Ptr_4,	A
	movf	Phase_Accum_4 + 1,	W,  A
	addwfc	Lookup_Ptr_4 + 1,	A
	movlw	0x00
	addwfc	Lookup_Ptr_4 + 2,	A
	bcf	TMR0IF		; clear interrupt flag
	retfie	f		; fast return from interrupt

	end
