lda #<{c2}
sta $fc
lda #>{c2}
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
cpy #<{c3}
bne !n-
cpx #>{c3}
bne !n-