lda {m1}+1
lsr
lda {m1}
ror
sta {m1}+1
lda #0
ror
sta {m1}
