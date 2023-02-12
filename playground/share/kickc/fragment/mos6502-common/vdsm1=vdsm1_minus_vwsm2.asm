lda {m2}+1
ora #$7f
bmi !+
lda #0
!:
sta $ff
sec
lda {m1}
sbc {m2}
sta {m1}
lda {m1}+1
sbc {m2}+1
sta {m1}+1
lda {m1}+2
sbc $ff
sta {m1}+2
lda {m1}+3
sbc $ff
sta {m1}+3
