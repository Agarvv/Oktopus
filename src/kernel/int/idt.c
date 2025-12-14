#include <include/kernel/idt/idt.h> 

void add_idt_handler(idt_index, unsigned short gdt_selector, unsigned char attributes, 
    unsigned short low_isr,
    unsigned short high_isr 
) {
    struct idt_endtry entry; 
    
    entry.isr_low = low_isr; 
    entry.gdt_selector = gdt_selector;
    entry.reserved = 0x00; 
    entry.attributes = attributes; 
    entry.isr_high = high_isr; 
    
    idt[index] = entry; 
}

void isr_divide_by_zero() {
   
}

idt[0] = add_idt_handler(0, 0x0008, 0x8E, (unsigned short)&isr_divide_by_zero, (unsigned short)(&isr_divide_by_zero >> 16)); 


void idt_start() {
    struct idtr idt_r;
    idt_r.idt_size = sizeof(idt); 
    idt_r.idt_start = &idt; 
    
    __asm__ volatile(
        "lidt, (%0)"
        : 
        : "r" (&idt_r)
        : "memory" 
    );
}