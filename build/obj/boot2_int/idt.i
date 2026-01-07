# 1 "src/bootloader/stage2/int/idt.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "src/bootloader/stage2/int/idt.c"
# 1 "include/bootloader/int/idt.h" 1


struct idt_entry {

    unsigned short isr_low;


    unsigned short gdt_selector;


    unsigned char reserved;


    unsigned char attributes;


    unsigned short isr_high;
} __attribute__((packed));

extern struct idt_entry idt[256];

struct idtr {
    unsigned short idt_size;
    struct idt_entry (*idt_start)[256];
} __attribute__((packed));

void idt_start();


void add_idt_handler(int idt_index,
                     unsigned short gdt_selector,
                     unsigned char attributes,
                     unsigned short isr_low,
                     unsigned short isr_high);

void isr_divide_by_zero();
void isr_invalid_opcode();
# 2 "src/bootloader/stage2/int/idt.c" 2


 struct idt_entry idt[256];
 int printg(int, int, char, char);
 extern void isr_dbz_stub(void);
 extern void isr_ioe_stub(void);


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
       "lidt (%0)"
        :
        : "r" (&idt_r)
        : "memory"
    );

}

int printg(int row, int col, char c, char f) {



    int offset = (row * 25) + col;
# 72 "src/bootloader/stage2/int/idt.c"
    unsigned short *addr = (unsigned short *)0xB8000 + offset;

    c = (unsigned short)c;

    f = (unsigned short)f;

    *addr = (f << 8) | c;

    return 0;
}
