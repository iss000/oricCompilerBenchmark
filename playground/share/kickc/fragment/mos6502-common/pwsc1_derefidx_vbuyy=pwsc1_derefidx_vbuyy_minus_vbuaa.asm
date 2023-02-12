clc
sbc {c1},y 
eor #$ff
sta {c1},y
bcc !+
lda {c1}+1,y
sbc #$01
sta {c1}+1,y
!: