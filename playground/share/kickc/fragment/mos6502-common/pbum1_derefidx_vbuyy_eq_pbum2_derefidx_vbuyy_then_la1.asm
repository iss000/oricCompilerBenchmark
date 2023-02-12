lda {m1}
sta $fc
lda {m1}+1
sta $fd
lda {m2}
sta $fe
lda {m2}+1
sta $ff
lda ($fc),y
cmp ($fe),y
beq {la1}

