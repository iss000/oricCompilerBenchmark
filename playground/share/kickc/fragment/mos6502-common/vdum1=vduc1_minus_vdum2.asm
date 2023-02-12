lda #<{c1}
sec
sbc {m2}
sta {m1}
lda #>{c1}
sbc {m2}+1
sta {m1}+1
lda #<{c1}>>$10
sbc {m2}+2
sta {m1}+2
lda #>{c1}>>$10
sbc {m2}+3
sta {m1}+3
