;
; SEDORIC access from C: file load/save and command invocation.
;
; Fresh OSDK implementation (2026). Credits:
; - Entry points, workspace names and calling conventions are from
;   "SEDORIC (3.0) a nu" by Andre Cheramy and Claude Sittler, the
;   commented disassembly of SEDORIC.
; - The load/save technique follows the one proven in the field by ISS's
;   GPL lib-sedoric (used as reference, not copied):
;     https://github.com/iss000/oricOpenLibrary/tree/main/lib-sedoric
;     https://forum.defence-force.org/viewtopic.php?t=2232
; - The C runtime zero page block is sheltered around every DOS call with
;   _zp_swap (see zeropage.s), so SEDORIC and the ROM can use page 0
;   freely while the C program's ap/fp/sp/tmp/reg survive.
;
; SEDORIC entry points and variables ("a nu" names):

#define SED_RAMROM   $04f2  ; jmp RAMROM: toggles the overlay RAM / ROM bank
#define SED_ERROR    $04fd  ; last DOS error number (page 4, always visible)
#define SED_ERRGOTO  $c018  ; ERRGOTO flag: b7=0 -> errors return to caller
#define SED_XNF      $d454  ; XNF secondary entry: parse the filename at
                            ; (TXTPTR) into BUFNOM; enter with A=0, C=0
#define SED_SAVEBIN  $de0b  ; common SAVE tail: LGSALO=FISALO-DESALO, XSAVEB
#define SED_XLOADA   $e0e5  ; XLOADA: load file per BUFNOM/VSALO/DESALO
#define SED_VSALO0   $c04d  ; SAve/LOad variant codes (b6/b7 = ,V ,N)
#define SED_VSALO1   $c04e  ; (b6/b7 = ,A ,J): $40 = ",A" load/save at DESALO
#define SED_LGSALO   $c04f  ; file length (2 bytes)
#define SED_FTYPE    $c051  ; file type: $40 = data block
#define SED_DESALO   $c052  ; start address (2 bytes)
#define SED_FISALO   $c054  ; end address (2 bytes)
#define SED_EXSALO   $c056  ; execution address (2 bytes)
#define SED_TXTPTR   $e9    ; BASIC/SEDORIC text pointer (2 bytes, zp)
#define SED_ZPINIT   $0b    ; zp byte initialised to 1 before DOS calls.
                            ; ISS's field-proven init; note "a nu" maps
                            ; FTYPE to $0D and calls $0B "sector rank" -
                            ; kept as proven pending hardware verification.

; Argument staging: filled from the C stack while the zero page is still
; ours, read back after the swap. sed_fname/sed_begin/sed_end stay
; contiguous - the entries copy them with one loop.

sed_fname       .byt 0,0    ; filename (C string, no quotes)
sed_begin       .byt 0,0    ; start address / load target
sed_end         .byt 0,0    ; end address (save), int *len out (load)
sed_size        .byt 0,0    ; length read back from LGSALO (load)
sed_txtsave     .byt 0,0    ; caller's TXTPTR, restored on exit


; int sed_savefile(const char *name, void *buf, unsigned int len);
;   Saves len bytes starting at buf as a data file. Returns the DOS error
;   number, 0 if the save succeeded.

_sed_savefile
.(
        ldy #5              ; stage name/buf/len from the C stack
loop
        lda (sp),y
        sta sed_fname,y
        dey
        bpl loop

        clc                 ; sed_end = buf + len - 1: SEDORIC end addresses
        lda sed_end         ; are INCLUSIVE (SAVE"F",A#A000,E#BF3F saves 8000
        adc sed_begin       ; bytes), so FISALO must hold the LAST byte
        sta sed_end
        lda sed_end+1
        adc sed_begin+1
        sta sed_end+1
        lda sed_end
        bne savedec
        dec sed_end+1
savedec
        dec sed_end

        jsr sed_open        ; shelter zp, bank in, parse filename

        ldx #3              ; DESALO/FISALO = begin/end (contiguous pairs)
loop2
        lda sed_begin,x
        sta SED_DESALO,x
        dex
        bpl loop2

        lda sed_begin       ; EXSALO = begin
        sta SED_EXSALO
        lda sed_begin+1
        sta SED_EXSALO+1

        lda #$00
        sta SED_VSALO0      ; plain SAVEO
        lda #$40
        sta SED_VSALO1
        sta SED_FTYPE       ; $40 = data block

        jsr SED_SAVEBIN
        jmp sed_close
.)

; int sed_loadfile(const char *name, void *buf, unsigned int *len);
;   Loads the file at address buf (",A" semantics), stores its length in
;   *len. Returns the DOS error number, 0 if the load succeeded.

_sed_loadfile
.(
        ldy #5              ; stage name/buf/&len from the C stack
loop
        lda (sp),y
        sta sed_fname,y
        dey
        bpl loop

        jsr sed_open        ; shelter zp, bank in, parse filename

        lda sed_begin
        sta SED_DESALO      ; load target
        lda sed_begin+1
        sta SED_DESALO+1
        lda #$00
        sta SED_VSALO0
        lda #$40            ; b6 = ",A": load at DESALO, not the file's own
        sta SED_VSALO1      ; address

        jsr SED_XLOADA

        lda SED_LGSALO      ; bring the size out of the overlay bank;
        clc                 ; LGSALO = FISALO-DESALO with an INCLUSIVE end,
        adc #1              ; so the real byte count is LGSALO+1
        sta sed_size
        lda SED_LGSALO+1
        adc #0
        sta sed_size+1

        jsr sed_close       ; bank out, restore zp; X = error, A = 0

        pha                 ; *len = sed_size (zp is ours again: tmp usable)
        lda sed_end
        sta tmp
        lda sed_end+1
        sta tmp+1
        ldy #0
        lda sed_size
        sta (tmp),y
        iny
        lda sed_size+1
        sta (tmp),y
        pla
        rts
.)

; Shared open: shelter the C zero page, save TXTPTR, bank in the overlay
; RAM, clear the error state and parse the filename into BUFNOM.
sed_open
        jsr _zp_swap
        lda SED_TXTPTR      ; the caller's TXTPTR must survive - clobbering
        sta sed_txtsave     ; it was the old sedoric()'s "syntax error on
        lda SED_TXTPTR+1    ; exit" bug
        sta sed_txtsave+1
        lda sed_fname
        sta SED_TXTPTR      ; XNF parses the name at (TXTPTR); the C string
        lda sed_fname+1     ; terminator ($00) is a valid end-of-name marker
        sta SED_TXTPTR+1
        jsr SED_RAMROM
        lda #1
        sta SED_ZPINIT
        lda #0
        sta SED_ERROR       ; not cleared by SEDORIC on success
        sta SED_ERRGOTO     ; b7=0: errors come back to us in SED_ERROR
        clc
        jmp SED_XNF         ; A=0, C=0: plain non-ambiguous filename

; Shared close: bank the overlay RAM out, restore TXTPTR and the C zero
; page, return the DOS error as an int (A=high=0, X=low).
sed_close
        jsr SED_RAMROM
        lda sed_txtsave
        sta SED_TXTPTR
        lda sed_txtsave+1
        sta SED_TXTPTR+1
        jsr _zp_swap
        ldx SED_ERROR
        lda #0
        rts


; void sedoric(const char *cmd);
;   Executes a SEDORIC command line, as if typed after "!". Rewritten: the
;   old version copied the command UNBOUNDED into the $35 line buffer -
;   which overlaps the C runtime zero page from $50 on, corrupting
;   ap/fp/sp for any command longer than 26 characters - and never
;   restored TXTPTR. The command is now bounded to the buffer (79 chars),
;   the C block is sheltered, and TXTPTR is restored on exit.

_sedoric
.(
        ldy #1              ; grab the command string pointer
        lda (sp),y
        sta sed_fname+1
        dey
        lda (sp),y
        sta sed_fname

        jsr _zp_swap        ; shelter the C block: $50..$7C now scratch

        lda SED_TXTPTR
        sta sed_txtsave
        lda SED_TXTPTR+1
        sta sed_txtsave+1

        lda sed_fname       ; tmp0 is sheltered, free as a copy pointer
        sta tmp0
        lda sed_fname+1
        sta tmp0+1
        ldy #0
loop                        ; copy the command to the $35 line buffer,
        lda (tmp0),y        ; bounded: $35+$4F = $84 is the last byte
        sta $35,y
        beq copied
        iny
        cpy #$4f
        bne loop
        lda #0              ; too long: truncate at 79 characters
        sta $35,y
copied
        lda #$35            ; point TXTPTR at the buffer, as the original
        sta SED_TXTPTR      ; did, and hand the line to the "!" handler
        lda #0
        sta SED_TXTPTR+1
        jsr $00e2           ; CHRGET: fetch the first token
        jsr sed_bang        ; the handler returns with rts

        lda sed_txtsave
        sta SED_TXTPTR
        lda sed_txtsave+1
        sta SED_TXTPTR+1
        jmp _zp_swap        ; restore the C block and return

sed_bang
        jmp ($02f5)         ; SEDORIC's "!" extension vector
.)
