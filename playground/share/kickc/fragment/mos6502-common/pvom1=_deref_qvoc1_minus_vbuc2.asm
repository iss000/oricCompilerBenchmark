lda {c1}
sec
sbc #{c2}
sta {m1}
lda {c1}+1
sbc #0
sta {m1}+1
