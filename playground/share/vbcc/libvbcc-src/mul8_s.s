 zpage r0
 zpage r1
 zpage r2
 zpage r3
 zpage ___m65mathptr
 section text
 global ___mulint8
___mulint8:
 lda r0
 sta $d770
 lda r1
 sta $d774
 lda $d778
 rts

