chmod +x kernel/comp.sh
chmod +x img.sh

echo "Bootloader Compilation..."
nasm -f bin main.S -o main.bin 

echo "Kernel Compilation..."
cd kernel 
./comp.sh 
cd .. 

echo "Compilation OK"

echo "Img Creation..."
rm f.img 
touch f.img 
sudo dd if=main.bin of=f.img bs=512 conv=notrunc
sudo dd if=kernel/kernel.bin of=f.img seek=1 bs=512 conv=notrunc

echo "Done!"