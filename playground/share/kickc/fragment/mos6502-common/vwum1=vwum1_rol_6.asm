lda {m1}+1
lsr
sta $ff
lda {m1}
ror
sta {m1}+1
lda #0
ror
sta {m1}
lsr $ff
ror {m1}+1
ror {m1}
