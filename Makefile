VERSION = 2.17.1
SRCLIB = /usr/share/cc65/lib/nes.lib
TGTLIB = runtime.lib
SRCDIR = src
OBJDIR = obj
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
	zip $(ARCHIVE) $(TGTLIB);\
	cd $(SRCDIR);\
	zip -r ../$(ARCHIVE) . -i \*.h ;\
	zip -r ../$(ARCHIVE) board 

all: clean $(ARCHIVE)
	$(info Done)

.SECONDEXPANSION:

$(OBJDIR)/%.o: $(SRCDIR)/%.s | $$(@D)/.
	$(CA) $< -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.inc | $$(@D)/.
	$(CA) $< -o $@

.PRECIOUS: $(OBJDIR)/. $(OBJDIR)%/.

$(OBJDIR)/.:
	$(call MKDIR,$@)

$(OBJDIR)%/.:
	$(call MKDIR,$@)

.PHONY: clean

clean:
	$(RM) $(OBJS) $(DEPS) $(TGTLIB) $(ARCHIVE)
