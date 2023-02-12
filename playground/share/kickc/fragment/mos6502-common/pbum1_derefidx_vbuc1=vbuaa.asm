ldy {m1}
sty $fe
ldy {m1}+1
sty $ff
ldy #{c1}
sta ($fe),y
