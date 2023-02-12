lda {c1},y
asl
sta {m1}
lda {c1}+1,y
rol
sta {m1}+1
asl {m1}
rol {m1}+1
