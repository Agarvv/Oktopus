
int start() {
asm volatile (
    "mov $0x5555555555555555, %%rax"
    :
    :
    : "rax"
);

return 0; 

}
