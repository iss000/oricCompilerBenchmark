sta $fe
ora #$7f
bmi !+
lda #0
!:
sta $ff
lda {m2}
sec
sbc $fe
sta {m1}
lda {m2}+1
sbc $ff
sta {m1}+1
