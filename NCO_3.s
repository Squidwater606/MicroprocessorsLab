#include <xc.inc>
	
global	Phase_Setup_3, IO_Setup_3, Lookup_Setup_3, NCO_Int_Hi_3  ; global routines
extrn	Lookup_Table	; global data

psect	udata_acs   ; reserve data space in access ram
Phase_Jump_3:	ds  2
Phase_Accum_3:	ds  2
Lookup_Ptr_3:	ds  3

psect	nco_code_3, class=CODE

Phase_Setup_3:
	clrf	Phase_Accum_3 + 1,    A
	clrf	Phase_Accum_3,	    A
	clrf	Phase_Jump_3 + 1,	    A
	clrf	Phase_Jump_3,	    A
	movlw	0xB8
	movwf	Phase_Jump_3,	    A
	movlw	0x01
	movwf	Phase_Jump_3 + 1,	    A
	return

IO_Setup_3:
	clrf	TRISG,	A	; Set PORTG as all outputs
	clrf	LATG,	A	; Clear PORTG outputs
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

NCO_Int_Hi_3:	
	btfss	TMR0IF		; check that this is timer0 interrupt
	retfie	f		; if not then return
Pointer_Ld_3:
	movf	Lookup_Ptr_3 + 2, W, A
	movwf	TBLPTRU,	   A
	movf	Lookup_Ptr_3 + 1, W, A
	movwf	TBLPTRH,	   A
	movf	Lookup_Ptr_3,	W, A
	movwf	TBLPTRL,	   A
Phase_Amp_3:
	tblrd*
	movff	TABLAT, LATG
Re_Init_3:
	movlw	low highword(Lookup_Table)	; address of data in PM
	movwf	Lookup_Ptr_3 + 2,    A		; load upper bits to TBLPTRU
	movlw	high(Lookup_Table)		; address of data in PM
	movwf	Lookup_Ptr_3 + 1,    A		; load high byte to TBLPTRH
	movlw	low(Lookup_Table)		; address of data in PM
	movwf	Lookup_Ptr_3,	   A		; load low byte to TBLPTRL
Phase_Inc_3:
	movf	Phase_Jump_3, W,	A
	addwf	Phase_Accum_3,	A
	movf	Phase_Jump_3 + 1,	W,  A
	addwfc	Phase_Accum_3 + 1,    A
Pointer_Inc_3:
	movf	Phase_Accum_3,	W,  A
	addwf	Lookup_Ptr_3,	A
	movf	Phase_Accum_3 + 1,	W,  A
	addwfc	Lookup_Ptr_3 + 1,	A
	movlw	0x00
	addwfc	Lookup_Ptr_3 + 2,	A
	bcf	TMR0IF		; clear interrupt flag
	retfie	f		; fast return from interrupt

	end
