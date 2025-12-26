#include <kernel/main/longmode.h>
#include <kernel/main/paging.h>


void enable_physical_addr_extension() {
  // to enable PAE, i have to set bit 5 of CR4 register to 1. 
    asm volatile(
        "movl %%cr4, %%eax\n\t"
        "orl $0x20, %%eax\n\t"      
        "movl %%eax, %%cr4"
        ::: "eax", "memory"
    );
}

void enable_long_mode() {
  // in order to activate long mode, i have to set bit eigth (Long mode enable) of EFER msr to 1
  asm volatile(
    "movl $0xC0000080, %%ecx\n\t" // EFER model speciific register number
    "rdmsr\n\t"                  // puts EFER high bits in edx and low bits in eax 
    "orl  $0x00000100, %%eax\n\t" // set bit 8 of low bits to 1 (Long mode enable)
    "wrmsr\n\t"                  // write model specific register
    :
    :
    : "eax", "edx", "ecx"
  );
}

void long_mode_start() {
  enable_four_level_paging(); 
  enable_physical_addr_extension(); 
  enable_long_mode(); 
}
