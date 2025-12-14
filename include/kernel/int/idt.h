#define IDT_SIZE 256

struct __attribute__((packed)) idt_entry {
    // lower bits of isr (16 bits)
    unsigned short isr_low 
    
    //gdt selector (16 bits)
    unsigned short gdt_selector
    
    // reserved for future use (8 bits)
    unsigned char reserved 
    
    // attributes (8 bits)
    unsigned char attributes 
    
    // high bits of isr (16 bits)
    unsigned short isr_high 
}; 

struct idt_entry idt[IDT_SIZE]; 

struct idtr {
    unsigned short idt_size; 
    unsigned int idt_start; 
}; 

void idt_start(); 

void add_idt_handler
(  
idt_index,

unsigned short gdt_selector, 

unsigned char attributes,

*isr
); 

void isr_divide_by_zero(); 