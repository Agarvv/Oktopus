#include <kernel/main/longmode.h>
#include <kernel/main/paging.h>

void enable_physical_addr_extension() {
 
}

void enable_long_mode() {

}

void enable_long_mode() {
  enable_physical_addr_extension(); 
  enable_four_level_paging(); 
  enable_long_mode(); 
}
