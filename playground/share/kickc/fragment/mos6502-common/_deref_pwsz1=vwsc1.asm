ldy #0
lda #<{c1}
sta ({z1}),y
iny
lda #>{c1}
sta ({z1}),y
