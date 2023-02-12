lda {c1}+1,y
sta {m1}
ora #$7f
bmi !+
lda #0
!:
sta {m1}+1
