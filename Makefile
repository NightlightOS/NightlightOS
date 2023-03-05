all: build

BOOTLOADER_ASM := $(wildcard bootloader/*.asm)
KERNEL_ASM := $(wildcard kernel/*.asm)

build: bootloader kernel
	@cat bin/bootloader.bin bin/kernel.bin > nightlight.bin
	@dd if=nightlight.bin of=nightlight.flp conv=notrunc status=none
	@truncate -s 737280 nightlight.flp
	@echo " OUT       nightlight.flp"

bootloader: bin/bootloader.bin
kernel: bin/kernel.bin

bin/bootloader.bin: $(BOOTLOADER_ASM) | forcedir
	@nasm -f bin bootloader/boot.asm -o bin/bootloader.bin
	@echo " NASM      bootloader"

bin/kernel.bin: $(KERNEL_ASM) | forcedir
	@nasm -f bin kernel/kernel.asm -o bin/kernel.bin
	@echo " NASM      kernel"

.PHONY: run
run: build
	qemu-system-x86_64 -fda nightlight.flp

.PHONY: clean
clean:
	rm -f bin/* *.bin *.flp

.PHONY: forcedir
forcedir:
	@mkdir -p bin
