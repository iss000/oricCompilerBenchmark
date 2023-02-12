stx $ff
sec
lda {c1},y
sbc $ff
sta {c1},y
lda {c1}+1,y
sbc #0
sta {c1},y
