#include <kernel/main/paging.h>

void enable_four_level_paging() {
	unsigned long long addr = (unsigned long long)&page_directory_pointer_table << 12; 
	page_map_level_four[0] = 0x0000000000000001 | addr; 
    
}
 