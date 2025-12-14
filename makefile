
CC      := clang
LD      := ld
QEMU    := qemu-system-i386


SRC_DIR := src/kernel
INC_DIR := include
BUILD   := build
OBJ_DIR := $(BUILD)/obj


KERNEL_ELF := $(BUILD)/kernel.elf
KERNEL_BIN := $(BUILD)/kernel.bin
IMG        := $(BUILD)/disk.img
BOOTLOADER := src/bootloader/main.bin


CFLAGS  := -target i686-none-elf -m32 -ffreestanding \
           -fno-builtin -fno-stack-protector -nostdlib -O0 \
           -I$(INC_DIR)

LDFLAGS := -m elf_i386 -T linker.ld


SRC := $(shell find $(SRC_DIR) -name "*.c")
OBJ := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC))


all: $(IMG)


$(KERNEL_ELF): $(OBJ)
	$(LD) $(LDFLAGS) $(OBJ) -o $@

$(KERNEL_BIN): $(KERNEL_ELF)
	objcopy -O binary $< $@


$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@


$(IMG): $(BOOTLOADER) $(KERNEL_BIN)
	rm -f $(IMG)
	dd if=/dev/zero of=$(IMG) bs=512 count=2880


	dd if=$(BOOTLOADER) of=$(IMG) conv=notrunc

	dd if=$(KERNEL_BIN) of=$(IMG) bs=512 seek=1 conv=notrunc


run: $(IMG)
	$(QEMU) -drive format=raw,file=$(IMG)


clean:
	rm -rf $(BUILD)


