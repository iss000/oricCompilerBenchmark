;
; conio-style console output, as used by portable 6502 test/benchmark code
; (e.g. the ISS MOS6502 compiler benchmark):
;   void _putc(char c);        print one character
;   void _puts(const char* s); print a string, WITHOUT the trailing newline
;                              that the standard puts() appends
; Both route through putchar (gpchar.s) so LF handling matches the rest of
; the console output.
;

__putc
	ldy #0
	lda (sp),y
	jmp putchar

__puts
	ldy #0
	lda (sp),y
	sta tmp
	iny
	lda (sp),y
	sta tmp+1
	ldy #0
cputs_loop
	lda (tmp),y
	beq cputs_done
	jsr putchar
	iny
	bne cputs_loop
	inc tmp+1
	jmp cputs_loop
cputs_done
	rts
