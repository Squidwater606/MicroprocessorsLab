#include <xc.inc>
	
global	NCO_Int_Hi  ; global routines
extrn	Lookup_Table	; global data

psect	udata_acs   ; reserve data space in access ram
Phase_Jump_1:	ds  2
Phase_Accum_1:	ds  2
Lookup_Ptr_1:	ds  3

psect	nco_int_code, class=CODE


 NCO_Int_Hi:
	btfss	TMR0IF		; check that this is timer0 interrupt
	retfie	f		; if not then return
Pointer_Ld_1:
	movf	Lookup_Ptr_1 + 2, W, A
	movwf	TBLPTRU,	   A
	movf	Lookup_Ptr_1 + 1, W, A
	movwf	TBLPTRH,	   A
	movf	Lookup_Ptr_1,	W, A
	movwf	TBLPTRL,	   A
Phase_Amp_1:
	tblrd*
	movff	TABLAT, LATJ
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
  Pointer_Ld_4:
	movf	Lookup_Ptr_4 + 2, W, A
	movwf	TBLPTRU,	   A
	movf	Lookup_Ptr_4 + 1, W, A
	movwf	TBLPTRH,	   A
	movf	Lookup_Ptr_4,	W, A
	movwf	TBLPTRL,	   A
 Phase_Amp_4:
	tblrd*
	movff	TABLAT, LATF
Re_Init:
	movlw	low highword(Lookup_Table)	; address of data in PM
	movwf	Lookup_Ptr_1 + 2,    A		; load upper bits to TBLPTRU
 	movwf	Lookup_Ptr_2 + 2,    A		; load upper bits to TBLPTRU
  	movwf	Lookup_Ptr_3 + 2,    A		; load upper bits to TBLPTRU
   	movwf	Lookup_Ptr_4 + 2,    A		; load upper bits to TBLPTRU
	movlw	high(Lookup_Table)		; address of data in PM
	movwf	Lookup_Ptr_1 + 1,    A		; load high byte to TBLPTRH
 	movwf	Lookup_Ptr_2 + 1,    A		; load high byte to TBLPTRH
  	movwf	Lookup_Ptr_3 + 1,    A		; load high byte to TBLPTRH
   	movwf	Lookup_Ptr_4 + 1,    A		; load high byte to TBLPTRH
	movlw	low(Lookup_Table)		; address of data in PM
	movwf	Lookup_Ptr_1,	   A		; load low byte to TBLPTRL
 	movwf	Lookup_Ptr_2,	   A		; load low byte to TBLPTRL
  	movwf	Lookup_Ptr_3,	   A		; load low byte to TBLPTRL
   	movwf	Lookup_Ptr_4,	   A		; load low byte to TBLPTRL
Phase_Inc_1:
	movf	Phase_Jump_1, W,	A
	addwf	Phase_Accum_1,	A
	movf	Phase_Jump_1 + 1,	W,  A
	addwfc	Phase_Accum_1 + 1,    A
 Phase_Inc_2:
	movf	Phase_Jump_2, W,	A
	addwf	Phase_Accum_2,	A
	movf	Phase_Jump_2 + 1,	W,  A
	addwfc	Phase_Accum_2 + 1,    A
 Phase_Inc_3:
	movf	Phase_Jump_3, W,	A
	addwf	Phase_Accum_3,	A
	movf	Phase_Jump_3 + 1,	W,  A
	addwfc	Phase_Accum_3 + 1,    A
 Phase_Inc_4:
	movf	Phase_Jump_4, W,	A
	addwf	Phase_Accum_4,	A
	movf	Phase_Jump_4 + 1,	W,  A
	addwfc	Phase_Accum_1 + 1,    A
Pointer_Inc_1:
	movf	Phase_Accum_1,	W,  A
	addwf	Lookup_Ptr_1,	A
	movf	Phase_Accum_1 + 1,	W,  A
	addwfc	Lookup_Ptr_1 + 1,	A
	movlw	0x00
	addwfc	Lookup_Ptr_1 + 2,	A
 Pointer_Inc_2:
	movf	Phase_Accum_2,	W,  A
	addwf	Lookup_Ptr_2,	A
	movf	Phase_Accum_2 + 1,	W,  A
	addwfc	Lookup_Ptr_2 + 1,	A
	movlw	0x00
	addwfc	Lookup_Ptr_2 + 2,	A
 Pointer_Inc_3:
	movf	Phase_Accum_3,	W,  A
	addwf	Lookup_Ptr_3,	A
	movf	Phase_Accum_3 + 1,	W,  A
	addwfc	Lookup_Ptr_3 + 1,	A
	movlw	0x00
	addwfc	Lookup_Ptr_3 + 2,	A
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

