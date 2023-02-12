lda {c1},x
sec
sbc #<{c2}
sta {c1},x
lda {c1}+1,x
sbc #>{c2}
sta {c1}+1,x