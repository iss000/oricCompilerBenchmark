lda {c1},x
asl
sta {m1}
lda {c1}+1,x
rol
sta {m1}+1
asl {m1}
rol {m1}+1
