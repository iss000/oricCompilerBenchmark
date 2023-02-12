lda {m2}+1
cmp #$80
ror
sta {m1}+1
lda {m2}
ror
sta {m1}
lda {m1}+1
cmp #$80
ror {m1}+1
ror {m1}
lda {m1}+1
cmp #$80
ror {m1}+1
ror {m1}

