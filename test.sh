nasm -f bin main.S -o main.bin
qemu-system-x86_64 -fda main.bin -vnc :1

