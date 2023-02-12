sec
sbc #{c1}
beq !e+
bvc !+
eor #$80
!:
bpl {la1}
!e: