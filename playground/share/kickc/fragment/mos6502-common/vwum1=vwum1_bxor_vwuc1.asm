lda #<{c1}
eor {m1}
sta {m1}
lda #>{c1}
eor {m1}+1
sta {m1}+1
