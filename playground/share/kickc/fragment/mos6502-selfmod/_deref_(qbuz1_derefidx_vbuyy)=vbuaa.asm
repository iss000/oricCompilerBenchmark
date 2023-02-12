pha
lda ({z1}),y
sta !+ +1
iny
lda ({z1}),y
sta !+ +2
pla
!: sta $ffff
