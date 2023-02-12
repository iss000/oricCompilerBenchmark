lda {c1},x
sec
sbc {c2},y
sta {m1}
lda {c1}+1,x
sbc {c2}+1,y
sta {m1}+1
