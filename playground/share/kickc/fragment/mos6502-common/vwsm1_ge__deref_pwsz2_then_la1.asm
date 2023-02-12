ldy #0
lda {m1}
cmp ({z2}),y
iny
lda {m1}+1
sbc ({z2}),y
bvc !+
eor #$80
!:
bpl {la1}
