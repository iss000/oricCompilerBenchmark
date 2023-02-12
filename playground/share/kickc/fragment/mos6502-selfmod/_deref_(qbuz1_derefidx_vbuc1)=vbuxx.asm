ldy #{c1}
lda ({z1}),y
sta !+ +1
iny
lda ({z1}),y
sta !+ +2
!: stx $ffff
