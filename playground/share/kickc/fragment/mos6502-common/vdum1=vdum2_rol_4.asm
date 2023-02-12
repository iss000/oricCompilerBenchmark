lda {m2}
asl
sta {m1}
lda {m2}+1
rol
sta {m1}+1
lda {m2}+2
rol
sta {m1}+2
lda {m2}+3
rol
sta {m1}+3
asl {m1}
rol {m1}+1
rol {m1}+2
rol {m1}+3
asl {m1}
rol {m1}+1
rol {m1}+2
rol {m1}+3
asl {m1}
rol {m1}+1
rol {m1}+2
rol {m1}+3
