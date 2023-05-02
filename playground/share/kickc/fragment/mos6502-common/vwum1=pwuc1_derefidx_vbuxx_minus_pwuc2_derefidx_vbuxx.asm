lda {c1},x
sec
sbc {c2},x
sta {m1}
lda {c1}+1,x
sbc {c2}+1,x
sta {m1}+1
