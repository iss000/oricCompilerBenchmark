sty $ff
lda {m2}
sec
sbc $ff
sta {m1}
lda {m2}+1
sbc #0
sta {m1}+1
