;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
			call	#CHAVES
			jmp		$

CHAVES:		mov.b	#0x0,P2DIR
			mov.b	#0x1,P1DIR
			mov.b	#0x80,P4DIR
			mov.b	#0x2,P1OUT
			mov.b	#0x2,P2OUT
			mov.b	#0x2,P1REN
			mov.b	#0x2,P2REN
LOOP:		mov.b	P1IN,R5
			mov.b	P2IN,R6
			bit		#2,R5
			jz		S1
			mov.b	#0,P4OUT
BACK:		bit		#2,R6
			jz		S2
			mov.b	#2,P1OUT
			jmp		LOOP
			ret

S1:			mov.b	#0x80,P4OUT
			jmp		BACK
S2:			mov.b	#0x3,P1OUT
			jmp		LOOP
			nop

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
