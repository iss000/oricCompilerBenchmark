ldy #0
lda ({z2}),y
sec
sbc #<{c1}
sta {m1}
iny
lda ({z2}),y
sbc #>{c1}
sta {m1}+1
