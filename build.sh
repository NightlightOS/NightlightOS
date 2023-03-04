mkdir -p bin

nasm -f bin bootloader/boot.asm -o bin/bootloader.bin
if [ $? -ne 0 ]; then
	exit
fi

nasm -f bin kernel/kernel.asm -o bin/kernel.bin
if [ $? -ne 0 ]; then
	exit
fi

cat bin/bootloader.bin bin/kernel.bin > nightlight.bin
dd if=nightlight.bin of=nightlight.flp conv=notrunc
truncate -s 737280 nightlight.flp
