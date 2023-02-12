clc
sbc {c1},x
eor #$ff
sta {c1},x
bcc !+
lda {c1}+1,x
sbc #$01
sta {c1}+1,x
!: