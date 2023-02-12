stx $ff
sec
lda {m2}
sbc $ff
sta {m1}
lda {m2}+1
sbc #0
sta {m1}+1
