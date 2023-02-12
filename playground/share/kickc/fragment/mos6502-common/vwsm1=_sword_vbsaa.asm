sta {m1}
// sign-extend the byte
ora #$7f 
bmi !+
lda #0
!:
sta {m1}+1
