#include <kernel/int/idt.h>
#include <kernel/terminal/terminal.h>
#include <kernel/drivers/video/vga/vga.h> 
#include <kernel/main/longmode.h>

__attribute__((section(".text.boot")))
void _start() {
    clear_terminal();  // makes the terminal clean and empty 
    
    idt_start();  // initializes the Interrupt Descriptor Table with entries  
    
    long_mode_start(); // Paging Config and Long mode Start 
    
  //  puts("Oktopu", 7); // Print "Oktopus" in clean terminal 

    while(1) {}   
}
