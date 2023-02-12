lda {m2}
sec
sbc #<{c1}
sta {m1}
lda {m2}+1
sbc #>{c1}
sta {m1}+1
lda {m2}+2
sbc #<{c1}>>$10
sta {m1}+2
lda {m2}+3
sbc #>{c1}>>$10
sta {m1}+3
