sec
lda #<{c1}
sbc {m2}
sta {m1}
lda #>{c1}
sbc #0
sta {m1}+1
