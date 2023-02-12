lda {c1},x
sec
sbc #<{c2}
sta {m1}
lda {c1}+1,x
sbc #>{c2}
sta {m1}+1
