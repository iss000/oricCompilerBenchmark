lda {c1}
sta $fe
lda {c1}+1
sta $ff
lda #<c2
sta ($fe),y
iny
lda #>c2
sta ($fe),y
