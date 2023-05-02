sec
lda {m2}
sbc #1
sta {m1}
lda {m2}+1
sbc #0
sta {m1}+1
lda {m2}+2
sbc #0
sta {m1}+2
lda {m2}+3
sbc #0
sta {m1}+3
