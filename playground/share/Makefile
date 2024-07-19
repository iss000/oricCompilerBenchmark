#)              _
#)  ___ ___ _ _|_|___ ___
#) |  _| .'|_'_| |_ -|_ -|
#) |_| |__,|_,_|_|___|___|
#)  iss@raxiss(c)2020,2023

ifeq "" "$(BASE)"
$(error            ? 'BASE' not defined)
endif

ifeq "" "$(BENCH)"
$(error            ? 'BENCH' not defined)
endif

ifeq "" "$(COMPILER)"
$(error            ? 'COMPILER' not defined)
endif

PWD                = $(shell pwd)

BASE               = ...
BENCH              = ...
BENCHD             = $(BENCH)
COMPILER           = ...

START              =  2048

SAMPLES            = $(PWD)/samples
TARGETBIN          = $(PWD)/bin/$(COMPILER)-$(BENCH).bin

BENCHDIR           = $(SAMPLES)/$(BENCHD)
BENCHFILE          = $(BENCHDIR)/$(BENCH)

BOOT0              =  boot0
SHARE              =  share
SYSROOT            =  $(PWD)/$(SHARE)/$(COMPILER)

CC                 = $(PWD)/$(SHARE)/$(COMPILER)/x-cc.sh
CA                 = $(PWD)/$(SHARE)/$(COMPILER)/x-ca.sh
LD                 = $(PWD)/$(SHARE)/$(COMPILER)/x-ld.sh
AR                 = $(PWD)/$(SHARE)/$(COMPILER)/x-ar.sh
BN                 = $(PWD)/$(SHARE)/$(COMPILER)/x-bin.sh

TOOLS              = $(CC) $(CA) $(LD) $(AR) $(BN)

DIROBJ               = obj/$(COMPILER)
TARGETDIRO         = $(DIROBJ)/$(BENCHD)
TARGETOUT          = $(TARGETDIRO)/$(BENCH)
TARGETPRG          = $(TARGETOUT).prg

INCLUDES           = -I$(BENCHDIR)

INCLUDES          += -I$(SHARE)/$(COMPILER)/include

ifeq "" "$(NOLIBS)"
INCLUDES          += -Ilibmos6502vm
endif

# Make does not offer a recursive wildcard function, so here's one:
rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))
# # How to recursively find all files with the same name in a given folder
# ALL_INDEX_HTMLS := $(call rwildcard,foo/,index.html)
# # How to recursively find all files that match a pattern
# ALL_HTMLS := $(call rwildcard,foo/,*.html)

LIBNONESRC         =
LIBNONEOBJ         =
LIBMOS6502VMSRC    =
LIBMOS6502VMOBJ    =
LIB$(COMPILER)SRC  =
LIB$(COMPILER)OBJ  =
LDFLAGS            =
LIBS               =

ifeq "" "$(NOLIBS)"

ifeq "" "$(NOLIBNONE)"
LIBS              += $(DIROBJ)/libnone.a
LDFLAGS           += -L$(DIROBJ)/libnone
LIBNONESRC        += $(call rwildcard,$(SHARE)/$(COMPILER)/libnone/,*.s)
LIBNONESRC        += $(call rwildcard,$(SHARE)/$(COMPILER)/libnone/,*.c)
LIBNONESRC        += $(call rwildcard,$(SHARE)/$(COMPILER)/libnone/,*.cc)
LIBNONESRC        += $(call rwildcard,$(SHARE)/$(COMPILER)/libnone/,*.cpp)
LIBNONEOBJ         = $(sort $(subst \
                     $(SHARE)/$(COMPILER)/libnone,\
                     $(DIROBJ)/libnone,\
                     $(subst .s,.o,\
                     $(subst .c,.o,\
                     $(subst .cc,.o,\
                     $(subst .cpp,.o,$(LIBNONESRC)))))))
endif

ifeq "" "$(NOLIBMOS6502VM)"
LIBS              += $(DIROBJ)/libmos6502vm.a
LDFLAGS           += -L$(DIROBJ)/libmos6502vm
LIBMOS6502VMSRC   += $(call rwildcard,libmos6502vm/,*.s)
LIBMOS6502VMSRC   += $(call rwildcard,libmos6502vm/,*.c)
LIBMOS6502VMSRC   += $(call rwildcard,libmos6502vm/,*.cc)
LIBMOS6502VMSRC   += $(call rwildcard,libmos6502vm/,*.cpp)
LIBMOS6502VMOBJ    = $(sort $(subst \
                     libmos6502vm,\
                     $(DIROBJ)/libmos6502vm,\
                     $(subst .s,.o,\
                     $(subst .c,.o,\
                     $(subst .cc,.o,\
                     $(subst .cpp,.o,$(LIBMOS6502VMSRC)))))))
endif

ifeq "" "$(NOLIB$(COMPILER))"
LIBS              += $(DIROBJ)/lib$(COMPILER)-src.a
LDFLAGS           += -L$(DIROBJ)/lib$(COMPILER)-src
LIB$(COMPILER)SRC += $(call rwildcard,$(SHARE)/$(COMPILER)/lib$(COMPILER)-src/,*.s)
LIB$(COMPILER)SRC += $(call rwildcard,$(SHARE)/$(COMPILER)/lib$(COMPILER)-src/,*.c)
LIB$(COMPILER)SRC += $(call rwildcard,$(SHARE)/$(COMPILER)/lib$(COMPILER)-src/,*.cc)
LIB$(COMPILER)SRC += $(call rwildcard,$(SHARE)/$(COMPILER)/lib$(COMPILER)-src/,*.cpp)
LIB$(COMPILER)OBJ  = $(sort $(subst \
                     $(SHARE)/$(COMPILER)/lib$(COMPILER)-src,\
                     $(DIROBJ)/lib$(COMPILER)-src,\
                     $(subst .s,.o,\
                     $(subst .c,.o,\
                     $(subst .cc,.o,\
                     $(subst .cpp,.o,$(LIB$(COMPILER)SRC)))))))
endif

LDFLAGS           += -L$(PWD)/$(SHARE)/$(COMPILER)/lib$(COMPILER)

endif # NOLIBS

TARGETSRC          =
TARGETOBJ          =

TARGETSRC         += $(call rwildcard,$(BENCHDIR)/,*.s)
TARGETSRC         += $(call rwildcard,$(BENCHDIR)/,*.c)
TARGETSRC         += $(call rwildcard,$(BENCHDIR)/,*.cc)
TARGETSRC         += $(call rwildcard,$(BENCHDIR)/,*.cpp)
TARGETOBJ          = $(sort $(subst \
                     $(BENCHDIR),\
                     $(TARGETDIRO),\
                     $(subst .s,.o,\
                     $(subst .c,.o,\
                     $(subst .cc,.o,\
                     $(subst .cpp,.o,$(TARGETSRC)))))))

####################################
Q                  = @
QQ                 = @
QQQ                = @true
SILENT             = >/dev/null 2>&1

CALL               = $(QQ) \
                   BASE="$(BASE)" \
                   START="$(START)" \
                   SYSROOT="$(SYSROOT)" \
                   INCLUDES="$(INCLUDES)" \
                   CFLAGS="$(CFLAGS)" \
                   OPT="$(OPT)" \
                   LDFLAGS="$(LDFLAGS)" \
                   LIBS="$(LIBS)" \
                   $(SILENT) \


####################################
.PHONY: all mrproper clean dirs love

all: $(TARGETBIN)

$(TARGETBIN): $(TARGETPRG)
	$(QQQ) "[BIN] $(notdir $@)"
	$(CALL) $(BN) $@ $<

$(TARGETPRG): dirs $(LIBS) $(DIROBJ)/$(BOOT0).o $(TARGETOBJ)
	$(QQQ) "[LNK] $(notdir $@)"
	$(CALL) $(LD) $@ $(DIROBJ)/$(BOOT0).o $(TARGETOBJ)



$(TARGETDIRO)/%.o: $(BENCHDIR)/%.s
	$(QQQ) "[ASM] $(notdir $@)"
	$(CALL) $(CA) $@ $<

$(TARGETDIRO)/%.o: $(BENCHDIR)/%.c
	$(QQQ) "[CPP] $(notdir $@)"
	$(CALL) $(CC) $@ $<

$(TARGETDIRO)/%.o: $(BENCHDIR)/%.cc
	$(QQQ) "[CPP] $(notdir $@)"
	$(CALL) $(CC) $@ $<

$(TARGETDIRO)/%.o: $(BENCHDIR)/%.cpp
	$(QQQ) "[CPP] $(notdir $@)"
	$(CALL) $(CC) $@ $<



$(DIROBJ)/%.o: $(SHARE)/$(COMPILER)/%.s
	$(QQQ) "[ASM] $(notdir $@)"
	$(CALL) $(CA) $@ $<

$(DIROBJ)/%.o: $(SHARE)/$(COMPILER)/%.c
	$(QQQ) "[CPP] $(notdir $@)"
	$(CALL) $(CC) $@ $<

$(DIROBJ)/%.o: $(SHARE)/$(COMPILER)/%.cc
	$(QQQ) "[CPP] $(notdir $@)"
	$(CALL) $(CC) $@ $<

$(DIROBJ)/%.o: $(SHARE)/$(COMPILER)/%.cpp
	$(QQQ) "[CPP] $(notdir $@)"
	$(CALL) $(CC) $@ $<


$(DIROBJ)/lib$(COMPILER)-src.a: $(LIB$(COMPILER)OBJ)
	$(QQQ) "[LIB] $(notdir $@)"
	$(CALL) LIBSRCDIR="$(SHARE)/$(COMPILER)/lib$(COMPILER)-src" $(AR) $@ $(LIB$(COMPILER)OBJ)

$(DIROBJ)/lib$(COMPILER)-src/%.o: $(SHARE)/$(COMPILER)/lib$(COMPILER)-src/%.s
	$(QQQ) "[ASM] $(notdir $@)"
	$(CALL) $(CA) $@ $<

$(DIROBJ)/lib$(COMPILER)-src/%.o: $(SHARE)/$(COMPILER)/lib$(COMPILER)-src/%.c
	$(QQQ) "[CPP] $(notdir $@)"
	$(CALL) $(CC) $@ $<

$(DIROBJ)/lib$(COMPILER)-src/%.o: $(SHARE)/$(COMPILER)/lib$(COMPILER)-src/%.cc
	$(QQQ) "[CPP] $(notdir $@)"
	$(CALL) $(CC) $@ $<

$(DIROBJ)/lib$(COMPILER)-src/%.o: $(SHARE)/$(COMPILER)/lib$(COMPILER)-src/%.cpp
	$(QQQ) "[CPP] $(notdir $@)"
	$(CALL) $(CC) $@ $<


$(DIROBJ)/libnone.a: $(LIBNONEOBJ)
	$(QQQ) "[LIB] $(notdir $@)"
	$(CALL) LIBSRCDIR="$(SHARE)/$(COMPILER)/libnone" $(AR) $@ $(LIBNONEOBJ)

$(DIROBJ)/libnone/%.o: $(SHARE)/$(COMPILER)/libnone/%.s
	$(QQQ) "[ASM] $(notdir $@)"
	$(CALL) $(CA) $@ $<

$(DIROBJ)/libnone/%.o: $(SHARE)/$(COMPILER)/libnone/%.c
	$(QQQ) "[CPP] $(notdir $@)"
	$(CALL) $(CC) $@ $<

$(DIROBJ)/libnone/%.o: $(SHARE)/$(COMPILER)/libnone/%.cc
	$(QQQ) "[CPP] $(notdir $@)"
	$(CALL) $(CC) $@ $<

$(DIROBJ)/libnone/%.o: $(SHARE)/$(COMPILER)/libnone/%.cpp
	$(QQQ) "[CPP] $(notdir $@)"
	$(CALL) $(CC) $@ $<


$(DIROBJ)/libmos6502vm.a: $(LIBMOS6502VMOBJ)
	$(QQQ) "[LIB] $(notdir $@)"
	$(CALL) LIBSRCDIR="libmos6502vm" $(AR) $@ $(LIBMOS6502VMOBJ)

$(DIROBJ)/libmos6502vm/%.o: libmos6502vm/%.s
	$(QQQ) "[ASM] $(notdir $@)"
	$(CALL) $(CA) $@ $<

$(DIROBJ)/libmos6502vm/%.o: libmos6502vm/%.c
	$(QQQ) "[CPP] $(notdir $@)"
	$(CALL) $(CC) $@ $<

$(DIROBJ)/libmos6502vm/%.o: libmos6502vm/%.cc
	$(QQQ) "[CPP] $(notdir $@)"
	$(CALL) $(CC) $@ $<

$(DIROBJ)/libmos6502vm/%.o: libmos6502vm/%.cpp
	$(QQQ) "[CPP] $(notdir $@)"
	$(CALL) $(CC) $@ $<


mrproper: clean
	$(Q) rm -rf $(DIROBJ)

clean:
	$(Q) rm -f $(TARGETBIN)
	$(Q) rm -rf $(TARGETDIRO)

dirs: clean
	$(Q) mkdir -p bin
	$(Q) mkdir -p $(TARGETDIRO)
	$(Q) mkdir -p $(DIROBJ)/libnone
	$(Q) mkdir -p $(DIROBJ)/libmos6502vm
	$(Q) mkdir -p $(DIROBJ)/lib$(COMPILER)-src
	$(Q) touch $(TOOLS) && chmod +x $(TOOLS)

love:
	@echo "$(notdir $@) ... not war!"
