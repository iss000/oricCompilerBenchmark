lda {c1},y
sec
sbc #<{c2}
sta {m1}
lda {c1}+1,y
sbc #>{c2}
sta {m1}+1
