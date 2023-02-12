sec
lda {m1}
sbc {m2}
sta {m1}
bcs !+
dec {m1}+1
!:
