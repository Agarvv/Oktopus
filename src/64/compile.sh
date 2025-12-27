clang -target x86_64-none-elf -m64 -ffreestanding \
      -nostdlib -fno-builtin -fno-stack-protector \
      -O0 -c -o kernel64.o kernel64.c

ld.lld -m elf_x86_64 -nostdlib --oformat=binary \
       -T l64.ld -o kernel64.bin kernel64.o

