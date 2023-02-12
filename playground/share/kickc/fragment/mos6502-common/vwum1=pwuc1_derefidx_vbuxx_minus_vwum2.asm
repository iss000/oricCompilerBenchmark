lda {c1},x
sec
sbc {m2}
sta {m1}
lda {c1}+1,x
sbc {m2}+1
sta {m1}+1
