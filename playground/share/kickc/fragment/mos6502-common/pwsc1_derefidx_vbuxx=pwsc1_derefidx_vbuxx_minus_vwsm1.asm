lda {c1},x
sec
sbc {m1}
sta {c1},x
lda {c1}+1,x
sbc {m1}+1
sta {c1}+1,x
