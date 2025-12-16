clang -target i686-none-elf -m32 -ffreestanding \
      -nostdlib -fno-builtin -fno-stack-protector \
      -O0 -I../../include -c -o main/kernel.o main/kernel.c

ld.lld -m elf_i386 -nostdlib --oformat=binary \
       -T l.ld -o main/kernel.bin main/kernel.o

