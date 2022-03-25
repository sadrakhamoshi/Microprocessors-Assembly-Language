.include "m32def.inc"
		LDI		R16,HIGH(RAMEND)
		OUT		SPH,R16
		LDI		R16,LOW(RAMEND)
		OUT		SPL,R16       
        

		LDI		R16,0xFF
		OUT		DDRC,R16		;PORTC as output
		OUT		DDRD,R16		;PORTD as output

		OUT		PORTA,R16		;Enabling Pullup Resistor on PORTA 
		LDI		R16,0x00
		OUT		DDRA,R16		;PORTA as input

SET_ZERO:
		LDI		R16,1			;FIRST_YEKAN
		LDI		R17,0			;FIRST_DAHGAN
		LDI     R18,1           ;SECOND_YEKAN
		LDI     R19,0           ;SECOND_DAHGAN
				
		RJMP	DISPLAY


BEGIN:
        ;CHECK CONDTION
        CPI     R19, 8
CHECK1:       
        BREQ    CHECK2
        RJMP    INCREMENT    

CHECK2: 
        CPI     R18, 9
        BREQ    SET_ZERO                   
        
INCREMENT:
        
        ;SUM       
        MOV     R29,R16     ;NEXT YEKAN
        MOV     R30,R17     ;NEXT DAHGAN
        ADD     R29,R18
        
        CPI     R29, 10
        BRCS    LL
        SUBI    R29, 10
        INC     R30                

LL:     
        ADD     R30, R19
        
        MOV     R16,R18
        MOV     R17,R19
        MOV     R18,R29
        MOV     R19,R30
        
        RJMP    DISPLAY

DISPLAY:

		MOV		R24,R19
		OUT		PORTC,R24
		;CALL	DELAY_DISP

		;LDI		R25,0b11110111	;displaying Yekan
;		OUT		PORTD,R25
		MOV		R24,R18
		;CALL	CONVERT
		OUT		PORTD,R24
		CALL	DELAY_DISP
		RJMP	BEGIN


DELAY_DISP:     
		LDI		R21,0x03
L1:		LDI		R22,0xFF
L2:		LDI		R23,0xFF
L3:		DEC		R23
		BRNE	L3
		DEC		R22
		BRNE	L2
		DEC		R21
		BRNE	L1
		RET
