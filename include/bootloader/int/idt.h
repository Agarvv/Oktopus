 #define IDT_SIZE 256

struct idt_entry {
    // lower bits of isr (16 bits)
    unsigned short isr_low; 
    
    // gdt selector (16 bits)
    unsigned short gdt_selector;
    
    // reserved for future use (8 bits)
    unsigned char reserved; 
    
    // attributes (8 bits)
    unsigned char attributes;  
    
    // high bits of isr (16 bits)
    unsigned short isr_high; 
} __attribute__((packed)); 

extern struct idt_entry idt[IDT_SIZE]; 

struct idtr {
    unsigned short idt_size; 
    struct idt_entry (*idt_start)[IDT_SIZE]; 
} __attribute__((packed)); 

void idt_start(); 


void add_idt_handler(int idt_index,
                     unsigned short gdt_selector, 
                     unsigned char attributes,
                     unsigned short isr_low, 
                     unsigned short isr_high); 

void isr_divide_by_zero();
void isr_invalid_opcode(); 
