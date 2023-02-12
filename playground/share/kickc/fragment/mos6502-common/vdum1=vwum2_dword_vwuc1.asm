lda #<{c1}
sta {m1}
lda #>{c1}
sta {m1}+1
lda {m2}
sta {m1}+2
lda {m2}+1
sta {m1}+3
