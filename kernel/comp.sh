clang -target i686-none-elf -m32 -ffreestanding \
      -nostdlib -fno-builtin -fno-stack-protector \
      -O0 -c -o kernel.o main.c 

ld.lld -m elf_i386 -nostdlib --oformat=binary \
       -T l.ld -o kernel.bin kernel.o

