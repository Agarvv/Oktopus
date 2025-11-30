nasm -f bin main.S -o main.bin
qemu-system-x86_64 -fda main.bin -drive format=raw,file=main.bin -nographic

