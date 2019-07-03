VERSION = 2.18.2
PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
PROJECT_DIR := $(PROJECT_DIR:/=)
SRCLIB = /usr/share/cc65/lib/nes.lib
TGTLIB = $(PROJECT_DIR)/lib/runtime.lib
SRCDIR = $(PROJECT_DIR)/src
CFGDIR = $(PROJECT_DIR)/cfg
INCDIR = $(PROJECT_DIR)/include
ASMDIR = $(PROJECT_DIR)/asminc
OBJDIR = $(PROJECT_DIR)/obj
SAMPLE = $(PROJECT_DIR)/samples
CA = ca65
AR = ar65

rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
CSOURCES = $(call rwildcard, $(SRCDIR), *.c)
SSOURCES = $(call rwildcard, $(SRCDIR), *.s)
DEPS := $(CSOURCES:.c=.d)
DEPS := $(DEPS:$(SRCDIR)/%=$(OBJDIR)/%)
OBJS := $(CRT0:.inc=.o) $(SSOURCES:.s=.o) $(CSOURCES:.c=.o)
OBJS := $(OBJS:$(SRCDIR)/%=$(OBJDIR)/%)
ARCHIVE := familib-$(VERSION).zip
AFLAGS := -I $(ASMDIR)

ifeq ($(shell echo),)
	MKDIR = mkdir -p $1
else
	MKDIR = mkdir $(subst /,\,$1)
endif

ifneq ($(MAKECMDGOALS),clean)
-include $(DEPS)
endif

$(TGTLIB): $(OBJS)
	cp $(SRCLIB) $@
	$(AR) a $@ $^

$(ARCHIVE): $(TGTLIB)
	zip -r $(ARCHIVE) $(TGTLIB:$(PROJECT_DIR)/%=%) $(CFGDIR:$(PROJECT_DIR)/%=%) $(ASMDIR:$(PROJECT_DIR)/%=%) $(INCDIR:$(PROJECT_DIR)/%=%) $(SAMPLE:$(PROJECT_DIR)/%=%)

all: clean $(ARCHIVE)
	$(info Done)

.SECONDEXPANSION:

$(OBJDIR)/%.o: $(SRCDIR)/%.s | $$(@D)/.
	$(CA) $(AFLAGS) $< -o $@

$(OBJDIR)/%.o: $(ASMDIR)/%.inc | $$(@D)/.
	$(CA) $(AFLAGS) $< -o $@

.PRECIOUS: $(OBJDIR)/. $(OBJDIR)%/.

$(OBJDIR)/.:
	$(call MKDIR,$@)

$(OBJDIR)%/.:
	$(call MKDIR,$@)

.PHONY: clean

clean:
	$(RM) $(OBJS) $(DEPS) $(TGTLIB) $(ARCHIVE)
