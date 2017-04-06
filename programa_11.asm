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
			call	#LEDS
			jmp		$

LEDS:		mov.b	#0x0,P2DIR
			mov.b	#0x1,P1DIR
			mov.b	#0x80,P4DIR
			mov.b	#0x2,P1OUT
			mov.b	#0x2,P2OUT
			mov.b	#0x2,P1REN
			mov.b	#0x2,P2REN
LOOP:		bit.b	#2,P1IN
			jnz		BACK
			call	#DEBOUNCING
			bit.b	#2,P1IN
			jz		S1
BACK:		bit.b	#2,P2IN
			jnz		LOOP
			call	#DEBOUNCING
			bit.b	#2,P2IN
			jz		S2
			jmp		LOOP
			ret

S1:			xor.b	#0x80,P4OUT
			jmp		SOBE1
S2:			xor.b	#0x1,P1OUT
			jmp		SOBE2

DEBOUNCING:	mov 	#0xFFF,R15
HERE:		sub		#1,R15
			jnz		HERE
			ret

SOBE1:		bit.b	#2,P1IN
			jnz		LOOP
			bit.b	#2,P2IN
			jz		COMPL
			jmp		SOBE1

SOBE2:		bit.b	#2,P2IN
			jnz		LOOP
			bit.b	#2,P1IN
			jz		COMPL
			jmp		SOBE2

COMPL:		push.b	P1OUT
			push.b	P2OUT
			bis.b	#1,P1OUT
			bic.b	#0x80,P4OUT
			mov		#0xFFFF,R5
LOOP2:		dec		R5
			nop
			nop
			nop
			nop
			nop
			jnz		LOOP2
			xor.b	#1,P1OUT
			xor.b	#0x80,P4OUT
			bit.b	#2,P1IN
			jnz		POOP
			bit.b	#2,P2IN
			jnz		POOP
			jmp		LOOP2
POOP:		pop.b	P2OUT
			pop.b	P1OUT
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
            
