ldy #0
lda #<{c1}
eor ({z2}),y
sta ({z1}),y
iny
lda #>{c1}
eor ({z2}),y
sta ({z1}),y