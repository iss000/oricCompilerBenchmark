lda {c1},y
sec
sbc {m1}
sta {c1},y
lda {c1}+1,y
sbc #0
sta {c1}+1,y
