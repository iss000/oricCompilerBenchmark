sec
lda {m2}
sbc #<{c1}
sta {m1}
lda {m2}+1
sbc #>{c1}
sta {m1}+1
