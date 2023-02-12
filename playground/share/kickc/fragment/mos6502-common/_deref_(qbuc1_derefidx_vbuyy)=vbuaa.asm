ldx {c1},y
stx $fe
ldx {c1}+1,y
stx $ff
ldy #0
sta ($fe),y