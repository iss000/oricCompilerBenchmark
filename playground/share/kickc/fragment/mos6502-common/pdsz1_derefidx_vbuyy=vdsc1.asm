lda #<{c1}
sta ({z1}),y
iny
lda #>{c1}
sta ({z1}),y
iny
lda #<{c1}>>$10
sta ({z1}),y
iny
lda #>{c1}>>$10
sta ({z1}),y