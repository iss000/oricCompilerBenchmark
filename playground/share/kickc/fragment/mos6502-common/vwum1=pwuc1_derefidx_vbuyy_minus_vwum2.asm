sec
lda {c1},y
sbc {m2}
sta {m1}
lda {c1}+1,y
sbc {m2}+1
sta {m1}+1
