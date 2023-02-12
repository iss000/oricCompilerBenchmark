lda #<{c1}
eor ({z1}),y
sta ({z1}),y
iny
lda #>{c1}
eor ({z1}),y
sta ({z1}),y
