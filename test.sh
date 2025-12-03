nasm -f bin main.S -o main.bin
qemu-system-x86_64 -fda main.bin  -nographic
qemu-system-x86_64 -fda main.bin -display gtk -serial stdio
qemu-system-x86_64 -fda main.bin -vnc :0 -serial stdio


