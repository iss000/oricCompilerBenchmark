ldy {m1}
lda {c1},y
sec
sbc {m2}
sta {c1},y
lda {c1}+1,y
sbc {m2}+1
sta {c1}+1,y
