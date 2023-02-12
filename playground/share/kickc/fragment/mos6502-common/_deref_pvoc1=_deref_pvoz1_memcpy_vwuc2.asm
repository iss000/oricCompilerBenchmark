lda {z1}
sta $fc
lda {z1}+1
sta $fd
lda #<{c1}
sta $fe
lda #>{c1}
sta $ff
ldy #0
ldx #0
!n:
lda ($fc),y
sta ($fe),y
iny
cpy #$ff
bne !+
inc $fd
inc $ff
inx
!:
cpy #<{c2}
bne !n-
cpx #>{c2}
bne !n-