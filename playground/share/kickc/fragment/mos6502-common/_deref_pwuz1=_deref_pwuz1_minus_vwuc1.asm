ldy #0
lda ({z1}),y
sec
sbc #<{c1}
sta ({z1}),y
iny
lda ({z1}),y
sbc #>{c1}
sta ({z1}),y
