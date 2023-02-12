lda {m2}+1
sta {m1}
lda {m2}+2
sta {m1}+1
lda {m2}+3
sta {m1}+2
and #$80
beq !+
lda #$ff
!:
sta {m1}+3