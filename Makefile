all: build

bootloader: bin/bootloader.bin
kernel: bin/kernel.bin

build: bootloader kernel
	@cat bin/bootloader.bin bin/kernel.bin > nightlight.bin
	@dd if=nightlight.bin of=nightlight.flp conv=notrunc status=none
	@truncate -s 737280 nightlight.flp
	@echo " OUT       nightlight.flp"

bin/bootloader.bin: bootloader/boot.asm
	@nasm -f bin bootloader/boot.asm -o bin/bootloader.bin
	@echo " NASM      bootloader"

bin/kernel.bin: kernel/kernel.asm global/functions.asm
	@nasm -f bin kernel/kernel.asm -o bin/kernel.bin
	@echo " NASM      kernel"

.PHONY: run
run:
	qemu-system-x86_64 -fda nightlight.flp

.PHONY: clean
clean:
	rm -f bin/* *.bin *.flp