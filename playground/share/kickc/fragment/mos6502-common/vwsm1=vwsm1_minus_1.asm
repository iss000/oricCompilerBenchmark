sec
lda {m1}
sbc #1
sta {m1}
bcs !+
dec {m1}+1
!:
