ldy {z1}
lda {c1},y
sec
sbc {z2}
sta {c1},y
lda {c1}+1,y
sbc {z2}+1
sta {c1}+1,y