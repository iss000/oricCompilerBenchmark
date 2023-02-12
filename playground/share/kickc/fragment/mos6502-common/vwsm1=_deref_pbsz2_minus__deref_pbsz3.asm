ldy #0
sec
lda ({z2}),y
sbc ({z3}),y
sta {m1}
ora #$7f
bmi !+
lda #0
!:
sta {m1}+1
