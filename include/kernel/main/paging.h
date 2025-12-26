unsigned long long page_map_level_four[512] __attribute__((aligned(4096)));
// Bit 0: Present
// Bit 1: Read/Write
// Bit 2: User/Supervisor
// Bit 3: Page Write Through
// Bit 4: Page Cache Disable
// Bit 5: Accessed
// Bits 6-11: Ignored / Available to OS
// Bits 12-51: Physical address of PDPT
// Bits 52-62: Available to OS
// Bit 63: NX (No Execute)
// 0 00000000000 000000000000000000000000000000000000 000000 000011

unsigned long long page_directory_pointer_table[512] __attribute__((aligned(4096)));
// Bit 0: Present
// Bit 1: Read/Write
// Bit 2: User/Supervisor
// Bit 3: Page Write Through
// Bit 4: Page Cache Disable
// Bit 5: Accessed
// Bit 6: Dirty (for large pages)
// Bit 7: Page Size (1=1GB if supported)
// Bits 8-11: Ignored / Available to OS
// Bits 12-51: Physical address of PD
// Bits 52-62: Available to OS
// Bit 63: NX (No Execute)
//  0 0000000 000000000000000000000000000000000010 0000 00000011

unsigned long long page_directory[512] __attribute__((aligned(4096)));
// Bit 0: Present
// Bit 1: Read/Write
// Bit 2: User/Supervisor
// Bit 3: Page Write Through
// Bit 4: Page Cache Disable
// Bit 5: Accessed
// Bit 6: Dirty (for large pages)
// Bit 7: Page Size (1=2MB if supported)
// Bits 8-11: Ignored / Available to OS
// Bits 12-51: Physical address of PT or large page
// Bits 52-62: Available to OS
// Bit 63: NX (No Execute)
//  0 0000000 000000000000000000000000000000000011 0000 00000011

unsigned long long page_table[512] __attribute__((aligned(4096)));
// Bit 0: Present
// Bit 1: Read/Write
// Bit 2: User/Supervisor
// Bit 3: Page Write Through
// Bit 4: Page Cache Disable
// Bit 5: Accessed
// Bit 6: Dirty
// Bits 7-11: Ignored / Available to OS
// Bits 12-51: Physical address of 4 KB page
// Bits 52-62: Available to OS
// Bit 63: NX (No Execute)
// 0 00000 000000000000000000000000000000000100 00000 000011


void enable_four_level_paging();

