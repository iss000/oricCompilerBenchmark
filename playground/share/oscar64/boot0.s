.setcpu		      "6502"
.autoimport     on
.case		        on
.debuginfo	    off

.export         __STARTUP__ ; required and used internally
.import         _main

.segment        "STARTUP"

__STARTUP__:
_start:
                jmp _main
