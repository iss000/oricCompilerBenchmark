lda {m3}+1
ora #$7f
bmi !+
lda #0
!:
sta $ff
sec
lda {m2}
sbc {m3}
sta {m1}
lda {m2}+1
sbc {m3}+1
sta {m1}+1
lda {m2}+2
sbc $ff
sta {m1}+2
lda {m2}+3
sbc $ff
sta {m1}+3