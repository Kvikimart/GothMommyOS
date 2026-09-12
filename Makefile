ASM = nasm
CC = gcc
LD = ld

SRC_DIR = src
BUILD_DIR = build
ISO_DIR = iso

all: $(BUILD_DIR)/kernel.elf

$(BUILD_DIR)/kernel.elf: $(BUILD_DIR)/boot.o $(BUILD_DIR)/kernel.o $(BUILD_DIR)/picture.o
	$(LD) -m elf_i386 -T $(SRC_DIR)/linker.ld -o $@ $(BUILD_DIR)/boot.o $(BUILD_DIR)/picture.o $(BUILD_DIR)/kernel.o

$(BUILD_DIR)/boot.o: $(SRC_DIR)/boot.s
	mkdir -p $(BUILD_DIR)
	$(ASM) -f elf32 $< -o $@

$(BUILD_DIR)/picture.o: $(SRC_DIR)/picture.txt
	objcopy --input binary --output elf32-i386 --binary-architecture i386 $< $@

$(BUILD_DIR)/kernel.o: $(SRC_DIR)/kernel.c
	$(CC) -m32 -ffreestanding -fno-pie -fno-stack-protector -c $< -o $@

iso: $(BUILD_DIR)/kernel.elf
	mkdir -p $(ISO_DIR)/boot/grub
	cp $(BUILD_DIR)/kernel.elf $(ISO_DIR)/boot/kernel.elf
	printf '%s\n' 'set default=0' 'set timeout=0' '' 'menuentry "GothMommyOS" {' '    multiboot /boot/kernel.elf' '    boot' '}' > $(ISO_DIR)/boot/grub/grub.cfg
	grub-mkrescue -o GothMommyOS.iso $(ISO_DIR)

run: $(BUILD_DIR)/kernel.elf
	qemu-system-i386 -kernel $(BUILD_DIR)/kernel.elf -nographic

qemu: run

clean:
	rm -rf $(BUILD_DIR) $(ISO_DIR) GothMommyOS.iso
