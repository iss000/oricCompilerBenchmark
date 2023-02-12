lda {m1}+1
sta {m1}
ora #$7f
bmi !+
lda #0
!:
sta {m1}+1