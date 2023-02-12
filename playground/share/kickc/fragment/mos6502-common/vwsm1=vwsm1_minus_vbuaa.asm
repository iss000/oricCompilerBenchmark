clc
sbc {m1}
eor #$ff
sta {m1}
bcc !+
dec {m1}+1
!:
