lda {m1}
sec
sbc #{c1}
sta {m1}
bcs !+
dec {m1}+1
!:
