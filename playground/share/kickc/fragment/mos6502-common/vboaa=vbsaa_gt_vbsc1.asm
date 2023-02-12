sec
sbc #{c1}
beq !a+
bvs !+
eor #$80
!:
asl
lda #0
rol
!a: