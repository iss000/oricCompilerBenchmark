ldy {z2}
lda ({z3}),y
ora #<{c1}
sta ({z1}),y
iny
lda ({z3}),y
ora #>{c1}
sta ({z1}),y
