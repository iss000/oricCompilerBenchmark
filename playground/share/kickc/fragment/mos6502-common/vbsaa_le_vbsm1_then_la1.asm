sec
sbc {m1}
beq {la1}
bvc !+
eor #$80
!:
bmi {la1}
