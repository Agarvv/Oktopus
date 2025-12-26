#include <kernel/main/paging.h>

void enable_four_level_paging() {
	unsigned long long pdpt_addr = (unsigned long long)&page_directory_pointer_table << 12; 
	page_map_level_four[0] = 0x0000000000000001 | pdpt_addr; 
    
    unsigned long long pd_addr = (unsigned long long)&page_directory << 12; 
	page_directory_pointer_table[0] = 0x0000000000000001 | pd_addr;

	unsigned long long pt_addr = (unsigned long long)&page_table << 12; 
	page_directory[0] = 0x0000000000000001 | pt_addr;

	unsigned long long p_addr = 0x0000000000010000; 
	page_table[0] = 0x0000000000000001 | p_addr; 
    
	unsigned long long pml4_addr = (unsigned long long)&page_map_level_four << 12; 
	
	asm volatile(
    "mov %%eax, %%cr3\n\t"
    "or %%eax, %0\n\t"
    "mov %%cr3, %%eax"
    :
    : "r"(pml4_addr)
    : "eax", "memory"
   );
}
 