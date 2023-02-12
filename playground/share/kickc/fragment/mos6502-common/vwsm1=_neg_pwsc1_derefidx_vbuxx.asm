sec
lda #0
sbc {c1},x
sta {m1}
lda #0
sbc {c1}+1,x
sta {m1}+1