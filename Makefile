ASM=nasm

SRC_DIR = src
BUILD_DIR = build

$(BUILD_DIR)/GothMommyOS.img: $(BUILD_DIR)/main.bin
	cp $(BUILD_DIR)/main.bin  $(BUILD_DIR)/GothMommyOS.img
	truncate -s 1440k $(BUILD_DIR)/GothMommyOS.img

$(BUILD_DIR)/main.bin: $(SRC_DIR)/main.asm
	$(ASM) $(SRC_DIR)/main.asm -f bin -o $(BUILD_DIR)/main.bin