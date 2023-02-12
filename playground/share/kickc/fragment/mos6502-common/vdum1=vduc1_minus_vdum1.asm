lda #<{c1}
sec
sbc {m1}
sta {m1}
lda #>{c1}
sbc {m1}+1
sta {m1}+1
lda #<{c1}>>$10
sbc {m1}+2
sta {m1}+2
lda #>{c1}>>$10
sbc {m1}+3
sta {m1}+3
