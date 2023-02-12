lda {c1},y
sta $fe
lda {c1}+1,y
sta $ff
jsr {la1}
{la1}: @outside_flow
jmp ($fe)  @outside_flow