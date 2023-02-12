lda #<{c1}
eor {m2}
sta {m1}
lda #>{c1}
eor {m2}+1
sta {m1}+1
