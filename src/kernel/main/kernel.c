#include <kernel/int/idt.h>
#include <kernel/terminal/terminal.h>

__attribute__((section(".text.boot")))
void _start() {
    clear_terminal();  // makes the terminal clean and empty 
    
    idt_start();  // initializes the Interrupt Descriptor Table with entries  
    
    puts("Oktopus"); // Print "Oktopus" in clean terminal 
    
    while(1) {}   
}
