sec
lda {m2}
sbc #1
sta {m1}
bcs !+
lda {m2}+1
sbc #0
sta {m1}+1
!:
