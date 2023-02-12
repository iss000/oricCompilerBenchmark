lda {m1}
sta $fe
lda {m1}+1
sta $ff
lda #{c1}
sta ($fe),y
and #$80
beq !+
lda #$ff
!:
iny
sta ($fe),y
iny
sta ($fe),y
iny
sta ($fe),y