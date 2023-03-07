all: build

BOOTLOADER_ASM := $(wildcard bootloader/*.asm)
KERNEL_ASM := $(wildcard kernel/*.asm)

.PHONY: build programs

build: bootloader kernel
	cat bin/bootloader.bin bin/kernel.bin > nightlight.bin
	ysfs nightlight.bin addFile fs/init.nl /init.nl
	dd if=nightlight.bin of=nightlight.flp conv=notrunc status=none
	truncate -s 737280 nightlight.flp

bootloader: bin/bootloader.bin
kernel: bin/kernel.bin

programs:
	$(MAKE) -C programs

bin/bootloader.bin: $(BOOTLOADER_ASM) | forcedir
	nasm -f bin bootloader/boot.asm -o bin/bootloader.bin

bin/kernel.bin: $(KERNEL_ASM) | forcedir
	nasm -f bin kernel/kernel.asm -o bin/kernel.bin

.PHONY: run
run: build
	qemu-system-x86_64 -fda nightlight.flp

.PHONY: clean
clean:
	rm -f bin/* *.bin *.flp

.PHONY: forcedir
forcedir:
	mkdir -p bin
