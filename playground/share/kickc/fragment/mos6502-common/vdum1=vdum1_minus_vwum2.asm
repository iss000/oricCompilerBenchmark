lda {m1}
sec
sbc {m2}
sta {m1}
lda {m1}+1
sbc {m2}+1
sta {m1}+1
lda {m1}+2
sbc #0
sta {m1}+2
lda {m1}+3
sbc #0
sta {m1}+3