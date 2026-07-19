;
; CRT zero page variables (44 bytes)
;
; Most of the documentation/comments are from
; 'Another Approach to Instruction Set Architecture - VAX'
;
ap		.dsb 2		; Argument pointer - points to the base of the list of arguments or parameters in memory that are passed to the procedure
fp		.dsb 2		; Frame pointer - points to the base of the local variables of the procedure that are kept in memory (the stack frame)
sp		.dsb 2		; Stack pointer - points to the top of the stack

tmp0	.dsb 2
tmp1	.dsb 2
tmp2	.dsb 2
tmp3	.dsb 2
tmp4	.dsb 2
tmp5	.dsb 2
tmp6	.dsb 2
tmp7	.dsb 2

op1		.dsb 2
op2		.dsb 2

tmp		.dsb 2

reg0	.dsb 2
reg1	.dsb 2
reg2	.dsb 2
reg3	.dsb 2
reg4	.dsb 2
reg5	.dsb 2
reg6	.dsb 2
reg7	.dsb 2

;
; VIA hardware addresses
;
#define	VIA_PORTB		$0300  ; Input/Output register B
#define	VIA_PORTAH		$0301  ; Input/Output register A (with handshake)
#define	VIA_DDRB		$0302  ; Data Direction Register B
#define	VIA_DDRA		$0303  ; Data Direction Register A
#define	VIA_T1CL		$0304  ; Timer 1 low-order latches/counter
#define	VIA_T1CH       	$0305  ; Timer 1 high-order counter
#define	VIA_T1LL       	$0306  ; Timer 1 low-order latches
#define	VIA_T1LH       	$0307  ; Timer 1 high-order latches
#define	VIA_T2LL       	$0308  ; Timer 2 low-order latches/counter
#define	VIA_T2CH       	$0309  ; Timer 2 high-order counter
#define	VIA_SR        	$030A  ; Shift Register (Buggy on many Oric, do not use)
#define VIA_ACR         $030B  ; Auxiliary Control Register
#define	VIA_PCR        	$030C  ; Peripheral Control Register
#define	VIA_IFR			$030D  ; Interupt Flag Register
#define	VIA_IER			$030E  ; Interupt Enable Register
#define	VIA_PORTA      	$030F  ; Input/Output register A (without handshake)

#define VIA2_PORTB		$0320  ; The Telestrat has a second VIA
