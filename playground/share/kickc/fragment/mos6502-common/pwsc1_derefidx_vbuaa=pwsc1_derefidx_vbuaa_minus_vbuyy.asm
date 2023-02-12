sty $ff
tay
lda {c1},y
sec
sbc $ff
sta {c1},y
lda {c1}+1,y
sbc #$00
sta {c1}+1,y
