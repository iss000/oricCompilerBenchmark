sec
lda #<{c1}
sbc {c2},x
sta {m1}
lda #>{c1}
sbc {c2}+1,x
sta {m1}+1