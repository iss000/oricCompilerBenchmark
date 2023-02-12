lda {m2}+1
lsr
sta $ff
lda {m2}
ror
sta {m1}+1
lda #0
ror
sta {m1}
lsr $ff
ror {m1}+1
ror {m1}
