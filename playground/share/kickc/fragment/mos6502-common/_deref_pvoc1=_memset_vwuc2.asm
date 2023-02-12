lda #<{c1}
sta $fe
lda #>{c1}
sta $ff
lda #0
tay
tax
!n:
sta ($fe),y
iny
cpy #$ff
bne !+
inc $ff
inx
!:
cpy #<{c2}
bne !n-
cpx #>{c2}
bne !n-