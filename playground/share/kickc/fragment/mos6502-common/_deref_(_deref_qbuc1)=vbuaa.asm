ldy {c1}
sty $fe
ldy {c1}+1
sty $ff
ldy #0
sta ($fe),y