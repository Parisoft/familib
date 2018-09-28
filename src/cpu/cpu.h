// preserve registers A, X and Y on the stack
#define cpu_push_regs() \
  __asm__("pha");       \
  __asm__("txa");       \
  __asm__("pha");       \
  __asm__("tya");       \
  __asm__("pha");

// restore registers A, X and Y from the stack
#define cpu_pull_regs() \
  __asm__("pla");       \
  __asm__("tay");       \
  __asm__("pla");       \
  __asm__("tax");       \
  __asm__("pla");

// return from interrupt for use in nmi() and irq() functions
#define cpu_rti() __asm__("rti");

// enable irq
#define cpu_irq_on() __asm__("cli");

// disable irq
#define cpu_irq_off() __asm__("sei");