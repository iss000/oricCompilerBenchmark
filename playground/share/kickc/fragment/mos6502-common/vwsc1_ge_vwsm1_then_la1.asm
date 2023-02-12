lda #<{c1}
cmp {m1}
lda #>{c1}
sbc {m1}+1
bvc !+
eor #$80
!:
bpl {la1}
