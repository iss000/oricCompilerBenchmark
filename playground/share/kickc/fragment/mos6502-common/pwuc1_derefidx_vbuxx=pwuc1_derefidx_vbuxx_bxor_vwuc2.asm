lda {c1},x
eor #<{c2}
sta {c1},x
lda {c1}+1,x
eor #>{c2}
sta {c1}+1,x
