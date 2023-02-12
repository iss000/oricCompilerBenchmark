lda #<{c1}
sec
sbc {m2}
sta {m1}
lda #>{c1}
sbc {m2}+1
sta {m1}+1
