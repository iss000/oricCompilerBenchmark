sec
sbc {z1}
beq !e+
bvc !+
eor #$80
!:
bpl {la1}
!e: