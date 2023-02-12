lda {c1},y
sta !+ +1
lda {c1}+1,y
sta !+ +2
!:
jsr $0000