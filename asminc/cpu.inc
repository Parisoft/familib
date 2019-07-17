    .macro cpu_push_regs
    pha       
    txa       
    pha       
    tya       
    pha
    .endmac

    .macro cpu_pull_regs
    pla
    tay
    pla
    tax
    pla
    .endmac

    .macro cpu_irq_on 
    cli
    .endmac

    .macro cpu_irq_off
    sei
    .endmac