stx $ff
lda #<{c1}
sec
sbc $ff
sta {m1}
lda #>{c1}
sbc #00
sta {m1}+1