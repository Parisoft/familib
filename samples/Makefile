ROMNAME = mygame.nes
BOARD = nrom

FAMILIB_DIR = ../familib
FAMILIB_INC = $(FAMILIB_DIR)/include
FAMILIB_ASM = $(FAMILIB_DIR)/asminc
FAMILIB_CFG = $(FAMILIB_DIR)/cfg
FAMILIB_LIB = $(FAMILIB_DIR)/lib
SRCDIR = src
OBJDIR = obj
EMUEXE = mesen
EMUOPT = 2>/dev/null
MAP = $(ROMNAME:.nes=.m)
DBG = $(ROMNAME:.nes=.dbg)
LIB = $(FAMILIB_LIB)/runtime.lib
CC = cc65
CA = ca65
LD = ld65
CFLAGS = -t nes -Oirs -T -I $(FAMILIB_INC) -g
AFLAGS = -I $(FAMILIB_ASM) -g

rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
CSOURCES = $(call rwildcard, $(SRCDIR), *.c)
SSOURCES = $(call rwildcard, $(SRCDIR), *.s)
CRT0 = $(strip $(FAMILIB_ASM)/$(BOARD).inc)
CFGS = $(shell find $(FAMILIB_CFG) -name '$(BOARD).cfg')
CFGS := $(if $(CFGS), $(CFGS), $(shell find $(FAMILIB_CFG) -name '$(BOARD)-prg*.cfg'|sort))
BINS := $(CFGS:.cfg=.bin)
BINS := $(notdir $(BINS))
DEPS := $(CSOURCES:.c=.d)
DEPS := $(DEPS:$(SRCDIR)/%=$(OBJDIR)/%)
OBJS := $(OBJDIR)/$(notdir $(CRT0:.inc=.o)) $(SSOURCES:.s=.o) $(CSOURCES:.c=.o)
OBJS := $(OBJS:$(SRCDIR)/%=$(OBJDIR)/%)

ifeq ($(shell echo),)
	MKDIR = mkdir -p $1
else
	MKDIR = mkdir $(subst /,\,$1)
endif

ifneq ($(MAKECMDGOALS),clean)
-include $(DEPS)
endif

$(ROMNAME): $(BINS)
	cat $^ > $@
	$(RM) $(BINS)

%.bin: $(CFGS) $(CRT0) $(SSOURCES) $(OBJS) 
	$(LD) -C $(FAMILIB_CFG)/$(@:.bin=.cfg) --dbgfile $(DBG) -m $(MAP) -o $@ $(OBJS) $(LIB)

all: clean play

play: $(ROMNAME)
	$(EMUEXE) $(ROMNAME) $(EMUOPT)

.SECONDEXPANSION:

$(OBJDIR)/%.o: $(OBJDIR)/%.s | $$(@D)/.
	$(CA) $(AFLAGS) $< -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.s | $$(@D)/.
	$(CA) $(AFLAGS) $< -o $@

$(OBJDIR)/$(BOARD).o: $(FAMILIB_ASM)/$(BOARD).inc | $$(@D)/.
	$(CA) $(AFLAGS) $< -o $@

$(OBJDIR)/%.s: $(SRCDIR)/%.c | $$(@D)/.
	$(CC) $(CFLAGS) -o $@ --create-dep $(@:.s=.d) $<

.PRECIOUS: $(OBJDIR)/. $(OBJDIR)%/.

$(OBJDIR)/.:
	$(call MKDIR,$@)

$(OBJDIR)%/.:
	$(call MKDIR,$@)

.PHONY: clean

clean:
	$(RM) $(OBJS) $(OBJS:.o=.s) $(DBG) $(MAP) $(DEPS) $(BINS) $(ROMNAME)
