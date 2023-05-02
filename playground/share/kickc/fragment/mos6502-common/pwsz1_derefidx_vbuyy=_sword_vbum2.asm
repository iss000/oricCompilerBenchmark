lda {m2}
sta ({z1}),y
ora #$7F
bmi !+
lda #$00
!:
iny
sta ({z1}),y