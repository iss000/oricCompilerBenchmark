lda {m1}
sec
sbc #<{c1}
sta {m1}
lda {m1}+1
sbc #>{c1}
sta {m1}+1
lda {m1}+2
sbc #<{c1}>>$10
sta {m1}+2
lda {m1}+3
sbc #>{c1}>>$10
sta {m1}+3
