lda {m1}
asl
sta $ff
lda {m1}+1
rol
sta {m1}
lda #0
rol
sta {m1}+1
asl $ff
rol {m1}
rol {m1}+1
