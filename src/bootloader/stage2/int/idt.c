#include <bootloader/int/idt.h> 
#define VIDEO 0xB8000

 struct idt_entry idt[IDT_SIZE]; 
 int printg(int, int, char, char); 
 extern void isr_dbz_stub(void);  // divide by zero stub 
 extern void isr_ioe_stub(void); // invalid opcode exception stub


void add_idt_handler(int idt_index, unsigned short gdt_selector, unsigned char attributes, 
    unsigned short low_isr,
    unsigned short high_isr) {
 
    struct idt_entry entry; 
    
    entry.isr_low = low_isr; 
    entry.gdt_selector = gdt_selector;
    entry.reserved = 0x00; 
    entry.attributes = attributes; 
    entry.isr_high = high_isr; 
    
    idt[idt_index] = entry; 
}

void isr_divide_by_zero() {
  printg(1, 6, 'E', 0x1F); 
} 

void isr_invalid_opcode() { 
   printg(1, 6, 'I', 0x1F); 
}

void idt_start() {
    struct idtr idt_r;
     idt_r.idt_size = sizeof(idt) - 1; 
     idt_r.idt_start = &idt; 
    
    
  
    add_idt_handler(0, 0x0008, 0x8E, 
        (unsigned short)&isr_dbz_stub, 
        (unsigned short)(((unsigned long)&isr_dbz_stub) >> 16)  
    ); 

    add_idt_handler(6, 0x0008, 0x8E, 
        (unsigned short)&isr_ioe_stub, 
        (unsigned short)(((unsigned long)&isr_ioe_stub) >> 16)  
    );

    __asm__ volatile(
    "lidt %0"
    :
    : "m"(idt_r)   
    : "memory"
  );
 

}

int printg(int row, int col, char c, char f) {
   //  idt_start(); // loads a idt structure and puts some interrupts


    int offset = (row * 25) + col;
    
    // 00000 row
    // 00000
    // 00000
    // 00000
    // -00001


    unsigned short *addr = (unsigned short *)VIDEO + offset;

    c = (unsigned short)c;

    f = (unsigned short)f;

    *addr = (f << 8) | c;

    return 0;
}
