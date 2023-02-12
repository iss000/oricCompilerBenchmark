sec
lda {c1}
sbc #<{c2}
sta {c1}
lda {c1}+1
sbc #>{c2}
sta {c1}+1
