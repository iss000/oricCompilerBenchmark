sec
lda #0
sbc {c1},y
sta {m1}
lda #0
sbc {c1}+1,y
sta {m1}+1