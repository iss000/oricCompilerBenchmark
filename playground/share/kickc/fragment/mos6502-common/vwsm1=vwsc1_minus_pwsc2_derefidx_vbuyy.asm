sec
lda #<{c1}
sbc {c2},y
sta {m1}
lda #>{c1}
sbc {c2}+1,y
sta {m1}+1