lda {m1}
sta $ff
lda {m1}+1
sta {m1}
lda #0
bit {m1}+1
bpl !+
lda #$ff
!:
sta {m1}+1
rol $ff
rol {m1}
rol {m1}+1
rol $ff
rol {m1}
rol {m1}+1
