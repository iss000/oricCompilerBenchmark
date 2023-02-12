lda {c1},y
sec
sbc {c2},x
sta {m1}
lda {c1}+1,y
sbc {c2}+1,x
sta {m1}+1
