lda #<{c1}
sec
sbc {m1}
sta {m1}
lda #>{c1}
sbc {m1}+1
sta {m1}+1
