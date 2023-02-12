lda {c1},y
sec
sbc #<{c2}
sta {c1},y
lda {c1}+1,y
sbc #>{c2}
sta {c1}+1,y