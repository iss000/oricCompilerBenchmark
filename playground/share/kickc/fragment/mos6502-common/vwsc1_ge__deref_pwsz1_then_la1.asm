ldy #0
lda #<{c1}
cmp ({z1}),y
lda #>{c1}
iny
sbc ({z1}),y
bvc !+
eor #$80
!:
bpl {la1}