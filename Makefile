#
# Copyleft (c) 2021 iss
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

# edit your paths here
OSDK    := ${HOME}/work/projects/8Bit/devtools/osdk
CC65    := ${HOME}/work/projects/8Bit/devtools/cc65
VBCC    := ${HOME}/work/projects/8Bit/devtools/vbcc/vbcc6502_linux/vbcc

# use $600 as start address
START_ADDRESS := 1536


ifeq (cc65,$(with))
CC      := $(CC65)/bin/cc65
AS      := $(CC65)/bin/ca65
LD      := $(CC65)/bin/ld65
CFLAGS  := --standard cc65 -Oirs -T -g
AFLAGS  := -I$(CC65)/asminc
LFLAGS  := -C cfg-cc65/atmosc.cfg -vm $(CC65)/lib/atmos.lib -D__START_ADDRESS__=$(START_ADDRESS)

with-cc65: $(DEPS)
	@mkdir -p $(ODIR)/$(ITEMNAME) && rm -f $(ODIR)/$(ITEMNAME)/*
	@$(CC) $(CFLAGS) -DNAME=$(ITEMNAME) $(ITEMDEFS) src/$(ITEM)-main.c -o $(ODIR)/$(ITEMNAME)/$(ITEM).as65
	@$(AS) $(AFLAGS) $(ODIR)/$(ITEMNAME)/$(ITEM).as65
	@$(LD) -o $(ITEMNAME) $(ODIR)/$(ITEMNAME)/$(ITEM).o $(LFLAGS)
	@./tools/oheader.lua $(ITEMNAME) $(START_ADDRESS)
	@echo "cc65 size: $(ITEMNAME): `cat $(ITEMNAME)|wc -c` bytes"
	@mkdir -p $(DST) && cat $(ITEMNAME).tap > $(DST)/$(ITEMNAME).tap
	@rm -f $(ITEMNAME) $(ITEMNAME).tap

else
ifeq (osdk,$(with))
CX      := $(OSDK)/bin/cpp
X1FLAGS := -DXA -lang-c++ -I$(OSDK)/include -D__16BIT__ -D__NOFLOAT__ -nostdinc -Isrc
X2FLAGS := -DXA -lang-c++ -imacros $(OSDK)/macro/macros-1.38.h -traditional -P
X3FLAGS := -DXA -lang-c++ -I$(OSDK)/include -D__16BIT__ -D__NOFLOAT__ -nostdinc -Isrc -P
CC      := $(OSDK)/bin/compiler-1.38 -Naes256
CFLAGS  := -O2
LD      := $(OSDK)/bin/link65
LFLAGS  := -c0 -q -d $(OSDK)/lib/
AS      := $(OSDK)/bin/xa-2.3.9
AFLAGS  := -M -W -bt $(START_ADDRESS)

with-osdk: $(DEPS)
	@mkdir -p $(ODIR)/$(ITEMNAME) && rm -f $(ODIR)/$(ITEMNAME)/*
	@$(CX) $(X1FLAGS) -DNAME=$(ITEMNAME) $(ITEMDEFS) src/$(ITEM)-main.c $(ODIR)/$(ITEMNAME)/$(ITEM).x1
	@$(CC) $(CFLAGS) $(ODIR)/$(ITEMNAME)/$(ITEM).x1 $(ODIR)/$(ITEMNAME)/$(ITEM).x2
	@$(CX) $(X2FLAGS) $(ODIR)/$(ITEMNAME)/$(ITEM).x2 $(ODIR)/$(ITEMNAME)/$(ITEM).x3
	@$(OSDK)/bin/macrosplitter $(ODIR)/$(ITEMNAME)/$(ITEM).x3 $(ODIR)/$(ITEMNAME)/$(ITEM).x4
	@$(LD) $(LFLAGS) -o $(ODIR)/$(ITEMNAME)/$(ITEM).x5 $(ODIR)/$(ITEMNAME)/$(ITEM).x4
	@$(CX) $(X3FLAGS) $(ODIR)/$(ITEMNAME)/$(ITEM).x5 $(ODIR)/$(ITEMNAME)/$(ITEM).x6
	@$(AS) $(AFLAGS) -o $(ITEMNAME) $(ODIR)/$(ITEMNAME)/$(ITEM).x6
	@./tools/oheader.lua $(ITEMNAME) $(START_ADDRESS)
	@echo "osdk size: $(ITEMNAME): `cat $(ITEMNAME)|wc -c` bytes"
	@mkdir -p $(DST) && cat $(ITEMNAME).tap > $(DST)/$(ITEMNAME).tap
	@rm -f $(ITEMNAME) $(ITEMNAME).tap

else
ifeq (vbcc,$(with))
CC      := $(VBCC)/bin/vc
AS      := $(VBCC)/bin/vasm6502_oldstyle
LD      := $(VBCC)/bin/vlink
CFLAGS  := -O3 -Isrc +cfg-vbcc/atmosc.cfg
AFLAGS  :=
LFLAGS  :=

with-vbcc: $(DEPS)
	@mkdir -p $(ODIR)/$(ITEMNAME) && rm -f $(ODIR)/$(ITEMNAME)/*
	@VBCC=$(VBCC) $(CC) $(CFLAGS) -DNAME=$(ITEMNAME) $(ITEMDEFS) src/$(ITEM)-main.c $(LFLAGS) -o $(ITEMNAME)
	@./tools/oheader.lua $(ITEMNAME) $(START_ADDRESS)
	@echo "vbcc size: $(ITEMNAME): `cat $(ITEMNAME)|wc -c` bytes"
	@mkdir -p $(DST) && cat $(ITEMNAME).tap > $(DST)/$(ITEMNAME).tap
	@rm -f $(ITEMNAME) $(ITEMNAME).tap $(ITEMNAME).inf

endif
endif
endif

ODIR    := obj-$(with)
DEPS    := Makefile $(wildcard src/*)

.PHONY: all clean with-cc65 with-osdk with-vbcc

all:
	@for i in cc65 osdk vbcc; do \
	\
	make --no-print-directory with=$$i with-$$i DST=tap-dummy ITEM=dummy ITEMNAME=dummy-$$i ITEMDEFS= && \
	\
	make --no-print-directory with=$$i with-$$i DST=tap-aes256 ITEM=aes256 ITEMNAME=aes256-$$i ITEMDEFS= && \
	make --no-print-directory with=$$i with-$$i DST=tap-aes256-tab ITEM=aes256 ITEMNAME=aes256-tab-$$i ITEMDEFS=-DBACK_TO_TABLES && \
	\
	true; done

clean:
	@rm -rf obj-*


# To be added ... one day.
# https://github.com/sehugg/sdcc-m6502
# https://github.com/jacobly0/llvm-project
# https://github.com/c64scene-ar/llvm-6502
# https://github.com/Peppar/llvm-C65 + https://github.com/Peppar/llvm-C65-sfc-example
# https://gitlab.com/camelot/kickc/-/releases
# https://github.com/RevCurtisP/C02
