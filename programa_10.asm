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
			call	#CONTA
			jmp		$

CONTA:		mov.b	#0x1,P1DIR
			mov.b	#0x80,P4DIR
			mov.b	#2,P1OUT
			mov.b	#0,P4OUT
			mov.b	#2,P1REN
			mov		#0,R5
LOOP:		mov.b	P1IN,R6
			bit		#2,R6
			jz		CLICK
			jmp		LOOP
			ret

CLICK:		inc		R5
			bit		#3,R5
			jz		ZERO
			bit		#1,R5
			jz		DOIS
			bit		#2,R5
			jz		UM
			bis.b	#0x80,P4OUT
			jmp		SOBE
ZERO:		bic.b	#1,P1OUT
			bic.b	#0x80,P4OUT
			jmp		SOBE
UM:			bis.b	#0x80,P4OUT
			jmp		SOBE
DOIS:		bic.b	#0x80,P4OUT
			bis.b	#1,P1OUT
SOBE:		mov.b	P1IN,R6
			bit		#2,R6
			jnz		BACK
			jmp		SOBE
BACK:		mov		#0xFFF,R7
HERE:		dec		R7
			jnz		HERE
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
            
