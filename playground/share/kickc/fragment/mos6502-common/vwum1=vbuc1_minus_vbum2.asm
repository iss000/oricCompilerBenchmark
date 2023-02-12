sec
lda #{c1}
sbc {m2}
sta {m1}
lda #0
sbc #0
sta {m1}+1
