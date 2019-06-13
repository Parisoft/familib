VERSION = 2.18.1
SRCLIB = /usr/share/cc65/lib/nes.lib
TGTLIB = lib/runtime.lib
SRCDIR = src
CFGDIR = cfg
INCDIR = include
ASMDIR = asminc
OBJDIR = obj
SAMPLE = samples
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
	zip -r $(ARCHIVE) $(TGTLIB) $(CFGDIR) $(ASMDIR) $(INCDIR) $(SAMPLE)

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
