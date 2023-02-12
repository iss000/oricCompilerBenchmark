lda {m2}+3
cmp #$80
ror
sta {m1}+3
lda {m2}+2
ror
sta {m1}+2
lda {m2}+1
ror
sta {m1}+1
lda {m2}
ror
sta {m1}
lda {m1}+3
cmp #$80
ror {m1}+3
ror {m1}+2
ror {m1}+1
ror {m1}