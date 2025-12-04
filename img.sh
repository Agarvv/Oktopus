nasm -f bin main.S -o main.bin
rm f.img 
touch f.img 
sudo dd if=main.bin of=f.img bs=512 conv=notrunc
sudo dd if=kernel/main.bin of=f.img seek=1 bs=512 conv=notrunc
