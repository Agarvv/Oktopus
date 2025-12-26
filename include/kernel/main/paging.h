unsigned int page_map_level_four[1024] __attribute__((aligned(4096)));
// Bit 0: Present
// Bit 1: Read/Write
// Bit 2: User/Supervisor
// Bit 3: Page Write Through
// Bit 4: Page Cache Disable
// Bit 5: Accessed
// Bits 6-11: Ignored / Available to OS
// Bits 12-31: Physical address of PDPT
// Bits 32-31: Available to OS
// Bit 31: NX (No Execute)
// 0 00000000000 00000000000000000000 000000 000011

unsigned int page_directory_pointer_table[1024] __attribute__((aligned(4096)));
// Bit 0: Present
// Bit 1: Read/Write
// Bit 2: User/Supervisor
// Bit 3: Page Write Through
// Bit 4: Page Cache Disable
// Bit 5: Accessed
// Bit 6: Dirty (for large pages)
// Bit 7: Page Size (1=1GB if supported)
// Bits 8-11: Ignored / Available to OS
// Bits 12-31: Physical address of PD
// Bits 32-31: Available to OS
// Bit 31: NX (No Execute)
//  0 0000000 00000000000000000000 0000 00000011

unsigned int page_directory[1024] __attribute__((aligned(4096)));
// Bit 0: Present
// Bit 1: Read/Write
// Bit 2: User/Supervisor
// Bit 3: Page Write Through
// Bit 4: Page Cache Disable
// Bit 5: Accessed
// Bit 6: Dirty (for large pages)
// Bit 7: Page Size (1=2MB if supported)
// Bits 8-11: Ignored / Available to OS
// Bits 12-31: Physical address of PT or large page
// Bits 32-31: Available to OS
// Bit 31: NX (No Execute)
//  0 0000000 00000000000000000000 0000 00000011

unsigned int page_table[1024] __attribute__((aligned(4096)));
// Bit 0: Present
// Bit 1: Read/Write
// Bit 2: User/Supervisor
// Bit 3: Page Write Through
// Bit 4: Page Cache Disable
// Bit 5: Accessed
// Bit 6: Dirty
// Bits 7-11: Ignored / Available to OS
// Bits 12-31: Physical address of 4 KB page
// Bits 32-31: Available to OS
// Bit 31: NX (No Execute)
// 0 00000 00000000000000000000 00000 000011


void enable_four_level_paging();
