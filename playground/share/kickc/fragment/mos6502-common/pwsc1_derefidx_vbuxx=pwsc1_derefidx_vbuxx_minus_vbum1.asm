lda {c1},x
sec
sbc {m1}
sta {c1},x
bcs !+
dec {c1}+1,x
!:
