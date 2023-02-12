lda {m1}
sec
sbc #<{c1}
sta {m1}
lda {m1}+1
sbc #>{c1}
sta {m1}+1
