lda ({z1}),y
sta $fe
iny
lda ({z1}),y
sta $ff
jsr {la1}
{la1}: @outside_flow
jmp ($fe)  @outside_flow