nasm -f bin main.S -o main.bin
qemu-system-x86_64 -fda main.bin  -nographic
qemu-system-x86_64 -fda main.bin -display gtk -serial stdio
qemu-system-x86_64 -fda main.bin -vnc :0 -serial stdio


qemu-system-x86_64 -fda f.img -display gtk -serial stdio



sudo dd if=main.bin of=f.img bs=512 conv=notrunc
sudo dd if=kernel/main.bin of=f.img seek=1 bs=512 conv=notrunc

qemu-system-x86_64 -hda f.img -display gtk -serial stdio

qemu-system-x86_64 -drive file=f.img,format=raw,if=ide -display gtk -serial stdio

qemu-system-x86_64 -hda f.img -nographic -serial mon:stdio