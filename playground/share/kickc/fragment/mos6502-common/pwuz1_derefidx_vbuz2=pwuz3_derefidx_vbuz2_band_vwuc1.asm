ldy {z2}
lda ({z3}),y
and #<{c1}
sta ({z1}),y
iny
lda ({z3}),y
and #>{c1}
sta ({z1}),y
