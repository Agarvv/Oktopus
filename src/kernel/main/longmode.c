#include <kernel/main/longmode.h>
#include <kernel/main/paging.h>

void enable_physical_addr_extension() {
 // to enable PAE, i have to set bit 5 of CR4 register to 1. 
 asm volatile(
		 "
  push eax 
  mov eax, cr4
  00000000 00000000 00000000 00A000000 
  OR eax, 0x00000020
  mov cr4, eax
  pop eax
 "
 ); 
}

void enable_long_mode() {

}

void enable_long_mode() {
  enable_physical_addr_extension(); 
  enable_four_level_paging(); 
  enable_long_mode(); 
}
