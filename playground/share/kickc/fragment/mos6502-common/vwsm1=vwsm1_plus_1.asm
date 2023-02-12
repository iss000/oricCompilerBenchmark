clc
lda {m1}
adc #1
sta {m1}
bcc !+
inc {m1}+1
!:
