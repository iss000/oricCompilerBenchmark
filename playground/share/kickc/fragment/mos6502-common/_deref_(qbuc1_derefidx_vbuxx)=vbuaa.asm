ldy {c1},x
sty $fe
ldy {c1}+1,x
sty $ff
ldy #0
sta ($fe),y