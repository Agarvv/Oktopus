#define VIDEO_MEMORY 0xB8000
#define VIDEO_ROWS 25 
#define VIDEO_COLS 80
#include <kernel/int/idt.h>

int printc(int, int, char, char); 

__attribute__((section(".text.boot")))
void _start() {
     //unsigned short *video_memory = (unsigned short *)VIDEO_MEMORY;
    // *video_memory = 0x1F61;  // blue, 'a'
     
    printc(0, 0, 'O', 0x1F); 
    printc(0, 1, 'k', 0x1F); 
    printc(0, 2, 't', 0x1F); 
    printc(0, 3, 'o', 0x1F); 
    printc(0, 4, 'p', 0x1F);
    printc(0, 5, 'u', 0x1F);
    printc(0, 6, 's', 0x1F); 
    idt_start();
    while(1) {}   
}

int printc(int row, int col, char c, char f) {
   //  idt_start(); // loads a idt structure and puts some interrupts 
    
    
    int offset = (row * VIDEO_ROWS) + col;
    // 00000 row 
    // 00000
    // 00000    
    // 00000
    // -00001
 

    unsigned short *addr = (unsigned short *)VIDEO_MEMORY + offset;

    c = (unsigned short)c;

    f = (unsigned short)f;

    *addr = (f << 8) | c;

    return 0; 
}
