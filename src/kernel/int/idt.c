#include <kernel/int/idt.h> 

 struct idt_entry idt[IDT_SIZE]; 


void add_idt_handler(int idt_index, unsigned short gdt_selector, unsigned char attributes, 
    unsigned short low_isr,
    unsigned short high_isr 
) {
    struct idt_entry entry; 
    
    entry.isr_low = low_isr; 
    entry.gdt_selector = gdt_selector;
    entry.reserved = 0x00; 
    entry.attributes = attributes; 
    entry.isr_high = high_isr; 
    
    idt[idt_index] = entry; 
}

void isr_divide_by_zero() {
   
}

void idt_start() {
      struct idtr idt_r;
     idt_r.idt_size = sizeof(idt) - 1; 
      idt_r.idt_start = &idt; 
    
  /* 
    add_idt_handler(0, 0x0008, 0x8E, 
        (unsigned short)&isr_divide_by_zero, 
        (unsigned short)(((unsigned long)&isr_divide_by_zero) >> 16)  
    );

    __asm__ volatile(
       "lidt (%0)"
        : 
        : "r" (&idt_r)
        : "memory" 
    ); */
}

