chmod +x src/kernel/comp.sh
chmod +x img.sh


echo "Bootloader Compilation..."
nasm -f bin src/bootloader/main.S -o  src/bootloader/main.bin 

echo "Kernel Compilation..."
cd src 
cd kernel
./comp.sh 
cd .. 
cd .. 

echo "Compilation OK"

echo "Img Creation..."
rm f.img 
touch f.img 
sudo dd if=src/bootloader/main.bin of=f.img bs=512 conv=notrunc
sudo dd if=src/kernel/main/kernel.bin of=f.img seek=1 bs=512 conv=notrunc

echo "Done!"
