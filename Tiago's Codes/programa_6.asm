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

			mov		#vetor, R5
			call	#ORDENA
			jmp 	$

ORDENA:		mov 	R5, R8
			mov.b 	@R5,R6
			inc		R8
			dec		R6
FOR1:		mov		R6, R7
			mov 	R8, R5
FOR2:		jmp		BOLHA
BACK:		dec		R7
			jnz		FOR2
			dec		R6
			jnz		FOR1
			ret

BOLHA:		mov.b	@R5,R9
			inc 	R5
			mov.b	@R5,R10
			cmp.b	R9, R10
			jhs		BACK
			dec		R5
			mov.b	R10,0(R5)
			inc 	R5
			mov.b	R9,0(R5)
			jmp		BACK
			nop


			.data
; Declarar vetor com 51 elementos [ THIAGOCARNEIROPITASERGIOAUGUSTOBARREIROSBITTENCOURT ]
vetor: 		.byte 51,'T','H','I','A','G','O','C','A','R','N','E','I','R','O','P','I','T','A','S','E','R','G','I','O'
;24
			.byte 'A', 'U', 'G', 'U','S', 'T', 'O', 'B', 'A', 'R', 'R', 'E', 'I', 'R', 'O', 'S'
			;16
			.byte 'B', 'I', 'T', 'T', 'E', 'N', 'C', 'O', 'U', 'R', 'T','A'
			;12


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
            
