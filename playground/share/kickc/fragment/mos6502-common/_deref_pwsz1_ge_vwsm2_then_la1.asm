ldy #0
lda ({z1}),y
cmp {m2}
iny
lda ({z1}),y
sbc {m2}+1
bvc !+
eor #$80
!:
bpl {la1}
