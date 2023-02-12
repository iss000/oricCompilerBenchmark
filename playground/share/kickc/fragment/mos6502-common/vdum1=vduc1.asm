lda #<{c1}
sta {m1}
lda #>{c1}
sta {m1}+1
lda #<{c1}>>$10
sta {m1}+2
lda #>{c1}>>$10
sta {m1}+3
