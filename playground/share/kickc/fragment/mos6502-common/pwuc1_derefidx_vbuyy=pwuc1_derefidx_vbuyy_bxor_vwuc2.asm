lda {c1},y
eor #<{c2}
sta {c1},y
lda {c1}+1,y
eor #>{c2}
sta {c1}+1,y
