#include <xc.inc>

//keypad takes inputs, generates outputs
//these can then be loaded into main.s or the DDS signal generator as need be

global  keyPad_Setup, keyPad_Read , delay, delay_count, value_1, value_2, value_3, value_4

psect   udata_acs	    ; reserve data space in access ram
col_1:	    ds 1
col_2:	    ds 1
value_1:    ds 2
value_2:    ds 2
value_3:    ds 2
value_4:    ds 2
;load_count: ds 1
;validate_count:	ds 1
delay_count: ds 1	    ; reserve one byte for counter in the delay routine

    
    
keyPad_Setup:   
    movlb   0x0F	    ; select bank 15 (contains PADCFG1)
    bcf     RCPU	    ; turn off pull-ups on C register
    movlb   0x00	    ;
    clrf    LATC, A	    ;write 0s to LATC register
    movlw   00001100b	    ;set RC2, RC3 to inputs
    movwf   TRISC, A	    ;RC0, RC1 are outputs; RC2, RC3 are inputs
    
    
    
keyPad_Read:
    ;one column should be pulled high, all other pins driven low, and then
    ; the values of RC2 and RC3 should be read and stored. the other column should then 
    ; be pulled high with all other pins driven low, and the same process repeated
    ;
    ;the stored values should then be combined into one hex number, and corresponded to
    ; a frequency, or combination of frequencies. 
    ;
    ;each hex number should output four numbers; if only one key is pressed,
    ; only one of the values will be >0, whereas is two keys are pressed, 
    ; two values will be >0, etc
    movlw   00000001B		;drive RC0 high
    movwf   LATC, A		;read port C
    call    delay		;delay
    movff   PORTC, col_1	;read values from RC2 and RC3, move to memory
    
    movlw   00000010B		;drive RC1 high
    movwf   LATC, A		;read port C
    call    delay		;delay
    movff   PORTC, col_2	;read values from RC2 and RC3, move to memory
    
    bra keyPad_Decode1
    
    
    
keyPad_Decode1:
    movlw   0x01		;move value of x01 to W 
    cpfseq  col_1, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode2	;if not, branch to next check
    bra	    keyPad_Decode5	;if yes, branch to col_2 check
    
keyPad_Decode2: 
    movlw   0x05		;if yes, move value of x05 to W 
    cpfseq  col_1, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode3	;if not, branch to next check
    bra	    keyPad_Decode9	;if yes, branch to col_2 check

keyPad_Decode3:
    movlw   0x09		;move value of x09 to W 
    cpfseq  col_1, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode4	;if not, branch to next check
    bra	    keyPad_Decode13	;if yes, branch to col_2 check
    
keyPad_Decode4:
    movlw   0x0D		;move value of x0D to W 
    cpfseq  col_1, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode1	;if not, branch to first check
    bra	    keyPad_Decode17	;if yes, branch to col_2 check

keyPad_Decode5:
    movlw   0x02		;move value of x02 to W 
    cpfseq  col_2, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode6	;if not, branch to next check
    bra	    keyPad_Value0	;if yes, move to value
    
keyPad_Decode6:
    movlw   0x06		;move value of x06 to W 
    cpfseq  col_2, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode7	;if not, branch to next check
    bra	    keyPad_Value2	;if yes, move to value
    
keyPad_Decode7:
    movlw   0x0A		;move value of x0A to W 
    cpfseq  col_2, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode8	;if not, branch to next check
    bra	    keyPad_Value4	;if yes, move to value
    
keyPad_Decode8:
    movlw   0x0E		;move value of x0E to W 
    cpfseq  col_2, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode1	;if not, branch to first check
    bra	    keyPad_Value2_4	;if yes, move to value
    
keyPad_Decode9:
    movlw   0x02		;move value of x02 to W 
    cpfseq  col_2, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode10	;if not, branch to next check
    bra	    keyPad_Value1	;if yes, move to value
    
keyPad_Decode10:
    movlw   0x06		;move value of x06 to W 
    cpfseq  col_2, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode11	;if not, branch to next check
    bra	    keyPad_Value1_2	;if yes, move to value
    
keyPad_Decode11:
    movlw   0x0A		;move value of x0A to W 
    cpfseq  col_2, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode12	;if not, branch to next check
    bra	    keyPad_Value1_4	;if yes, move to value
    
keyPad_Decode12:
    movlw   0x0E		;move value of x0E to W 
    cpfseq  col_2, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode1	;if not, branch to first check
    bra	    keyPad_Value1_2_4	;if yes, move to value
    
keyPad_Decode13:
    movlw   0x02		;move value of x02 to W 
    cpfseq  col_2, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode14	;if not, branch to next check
    bra	    keyPad_Value3	;if yes, move to value
    
keyPad_Decode14:
    movlw   0x06		;move value of x06 to W 
    cpfseq  col_2, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode15	;if not, branch to next check
    bra	    keyPad_Value2_3	;if yes, move to value
    
keyPad_Decode15:
    movlw   0x0A		;move value of x0A to W 
    cpfseq  col_2, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode16	;if not, branch to next check
    bra	    keyPad_Value3_4	;if yes, move to value
    
keyPad_Decode16:
    movlw   0x0E		;move value of x0E to W 
    cpfseq  col_2, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode1	;if not, branch to first check
    bra	    keyPad_Value2_3_4	;if yes, move to value
    
keyPad_Decode17:
    movlw   0x02		;move value of x02 to W 
    cpfseq  col_2, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode18	;if not, branch to next check
    bra	    keyPad_Value1_3	;if yes, move to value
    
keyPad_Decode18:
    movlw   0x06		;move value of x06 to W 
    cpfseq  col_2, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode19	;if not, branch to next check
    bra	    keyPad_Value1_2_3	;if yes, move to value
    
keyPad_Decode19:
    movlw   0x0A		;move value of x0A to W 
    cpfseq  col_2, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode20	;if not, branch to next check
    bra	    keyPad_Value1_3_4	;if yes, move to value
    
keyPad_Decode20:
    movlw   0x0E		;move value of x0E to W 
    cpfseq  col_2, A	;compare whether col_1 and W are equal
    bra	    keyPad_Decode1	;if not, branch to first check
    bra	    keyPad_Value1_2_3_4	;if yes, move to value
    
    
    
keyPad_Value0:
    movlw   0x00
    movwf   value_1, A
    movwf   value_1 + 1, A
    movlw   0x00
    movwf   value_2, A
    movwf   value_2 + 1, A
    movlw   0x00
    movwf   value_3, A
    movwf   value_3 + 1, A
    movlw   0x00
    movwf   value_4, A
    movwf   value_4 + 1, A
    return
    
keyPad_Value1:
    movlw   0xB8
    movwf   value_1, A
    movlw   0x01
    movwf   value_1 + 1, A
    movlw   0x00
    movwf   value_2, A
    movwf   value_2 + 1, A
    movlw   0x00
    movwf   value_3, A
    movwf   value_3 + 1, A
    movlw   0x00
    movwf   value_4, A
    movwf   value_4 + 1, A
    return
    
keyPad_Value2:
    movlw   0x00
    movwf   value_1, A
    movwf   value_1 + 1, A
    movlw   0x2A
    movwf   value_2, A
    movlw   0x02
    movwf   value_2 + 1, A
    movlw   0x00
    movwf   value_3, A
    movwf   value_3 + 1, A
    movlw   0x00
    movwf   value_4, A
    movwf   value_4 + 1, A
    return
    
keyPad_Value3:
    movlw   0x00
    movwf   value_1, A
    movwf   value_1 + 1, A
    movlw   0x00
    movwf   value_2, A
    movwf   value_2 + 1, A
    movlw   0x93
    movwf   value_3, A
    movlw   0x02
    movwf   value_3 + 1, A
    movlw   0x00
    movwf   value_4, A
    movwf   value_4 + 1, A
    return
    
keyPad_Value4:
    movlw   0x00
    movwf   value_1, A
    movwf   value_1 + 1, A
    movlw   0x00
    movwf   value_2, A
    movwf   value_2 + 1, A
    movlw   0x00
    movwf   value_3, A
    movwf   value_3 + 1, A
    movlw   0x3F
    movwf   value_4, A
    movlw   0x03
    movwf   value_4 + 1, A
    return
    
keyPad_Value1_2:
    movlw   0xB8
    movwf   value_1, A
    movlw   0x01
    movwf   value_1 + 1, A
    movlw   0x2A
    movwf   value_2, A
    movlw   0x02
    movwf   value_2 + 1, A
    movlw   0x00
    movwf   value_3, A
    movwf   value_3 + 1, A
    movlw   0x00
    movwf   value_4, A
    movwf   value_4 + 1, A
    return
    
keyPad_Value1_3:
    movlw   0xB8
    movwf   value_1, A
    movlw   0x01
    movwf   value_1 + 1, A
    movlw   0x00
    movwf   value_2, A
    movwf   value_2 + 1, A
    movlw   0x93
    movwf   value_3, A
    movlw   0x02
    movwf   value_3 + 1, A
    movlw   0x00
    movwf   value_4, A
    movwf   value_4 + 1, A
    return
    
keyPad_Value1_4:
    movlw   0xB8
    movwf   value_1, A
    movlw   0x01
    movwf   value_1 + 1, A
    movlw   0x00
    movwf   value_2, A
    movwf   value_2 + 1, A
    movlw   0x00
    movwf   value_3, A
    movwf   value_3 + 1, A
    movlw   0x3F
    movwf   value_4, A
    movlw   0x03
    movwf   value_4 + 1, A
    return
    
keyPad_Value2_3:
    movlw   0x00
    movwf   value_1, A
    movwf   value_1 + 1, A
    movlw   0x2A
    movwf   value_2, A
    movlw   0x02
    movwf   value_2 + 1, A
    movlw   0x93
    movwf   value_3, A
    movlw   0x02
    movwf   value_3 + 1, A
    movlw   0x00
    movwf   value_4, A
    movwf   value_4 + 1, A
    return
    
keyPad_Value2_4:
    movlw   0x00
    movwf   value_1, A
    movwf   value_1 + 1, A
    movlw   0x2A
    movwf   value_2, A
    movlw   0x02
    movwf   value_2 + 1, A
    movlw   0x00
    movwf   value_3, A
    movwf   value_3 + 1, A
    movlw   0x3F
    movwf   value_4, A
    movlw   0x03
    movwf   value_4 + 1, A
    return
 
keyPad_Value3_4:
    movlw   0x00
    movwf   value_1, A
    movwf   value_1 + 1, A
    movlw   0x00
    movwf   value_2, A
    movwf   value_2 + 1, A
    movlw   0x93
    movwf   value_3, A
    movlw   0x02
    movwf   value_3 + 1, A
    movlw   0x3F
    movwf   value_4, A
    movlw   0x03
    movwf   value_4 + 1, A
    return

keyPad_Value1_2_3:
    movlw   0xB8
    movwf   value_1, A
    movlw   0x01
    movwf   value_1 + 1, A
    movlw   0x2A
    movwf   value_2, A
    movlw   0x02
    movwf   value_2 + 1, A
    movlw   0x93
    movwf   value_3, A
    movlw   0x02
    movwf   value_3 + 1, A
    movlw   0x00
    movwf   value_4, A
    movwf   value_4 + 1, A
    return
    
keyPad_Value1_2_4:
    movlw   0xB8
    movwf   value_1, A
    movlw   0x01
    movwf   value_1 + 1, A
    movlw   0x2A
    movwf   value_2, A
    movlw   0x02
    movwf   value_2 + 1, A
    movlw   0x00
    movwf   value_3, A
    movwf   value_3 + 1, A
    movlw   0x3F
    movwf   value_4, A
    movlw   0x03
    movwf   value_4 + 1, A
    return
    
keyPad_Value1_3_4:
    movlw   0xB8
    movwf   value_1, A
    movlw   0x01
    movwf   value_1 + 1, A
    movlw   0x00
    movwf   value_2, A
    movwf   value_2 + 1, A
    movlw   0x93
    movwf   value_3, A
    movlw   0x02
    movwf   value_3 + 1, A
    movlw   0x3F
    movwf   value_4, A
    movlw   0x03
    movwf   value_4 + 1, A
    return
    
keyPad_Value2_3_4:
    movlw   0x00
    movwf   value_1, A
    movwf   value_1 + 1, A
    movlw   0x2A
    movwf   value_2, A
    movlw   0x02
    movwf   value_2 + 1, A
    movlw   0x93
    movwf   value_3, A
    movlw   0x02
    movwf   value_3 + 1, A
    movlw   0x3F
    movwf   value_4, A
    movlw   0x03
    movwf   value_4 + 1, A
    return
    
keyPad_Value1_2_3_4:
    movlw   0xB8
    movwf   value_1, A
    movlw   0x01
    movwf   value_1 + 1, A
    movlw   0x2A
    movwf   value_2, A
    movlw   0x02
    movwf   value_2 + 1, A
    movlw   0x93
    movwf   value_3, A
    movlw   0x02
    movwf   value_3 + 1, A
    movlw   0x3F
    movwf   value_4, A
    movlw   0x03
    movwf   value_4 + 1, A
    return

    
    
delay:
    decfsz  delay_count, A  ; decrement until zero
    bra     delay
    return
