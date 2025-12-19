CC      := clang
LD      := ld
QEMU    := qemu-system-i386

SRC_DIR := src/kernel
INC_DIR := include
BUILD   := build
OBJ_DIR := $(BUILD)/obj
ASM_OBJ := src/kernel/asm/stub/stub.o


KERNEL_ELF := $(BUILD)/kernel.elf
KERNEL_BIN := $(BUILD)/kernel.bin
IMG        := $(BUILD)/disk.img
BOOTLOADER := src/bootloader/main.bin

CFLAGS  := -target i686-none-elf -m32 -ffreestanding \
           -fno-builtin -fno-stack-protector -nostdlib -O0 \
           -I$(INC_DIR)

LDFLAGS := -m elf_i386 -T src/kernel/l.ld


ALL_SRC := $(shell find $(SRC_DIR) -name "*.c")


$(info === c files found  ===)
$(foreach src,$(ALL_SRC),$(info $(src)))


KERNEL_MAIN := $(shell find $(SRC_DIR) -name "kernel.c")
$(info === Kernel  ===)
$(info $(KERNEL_MAIN))


ifeq ($(KERNEL_MAIN),)
KERNEL_MAIN := $(firstword $(ALL_SRC))
$(warning kernel.c not found, using: $(KERNEL_MAIN))
endif


OTHER_SRC := $(filter-out $(KERNEL_MAIN), $(ALL_SRC))


OBJ := $(ASM_OBJ) \
       $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(KERNEL_MAIN)) \
       $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(OTHER_SRC))


$(info === objects  ===)
$(foreach obj,$(OBJ),$(info $(obj)))

all: $(IMG)

$(KERNEL_ELF): $(OBJ)
	@echo "=== kernel linking... ==="
	$(LD) $(LDFLAGS) $(OBJ) -o $@

	@echo "=== entry point === "
	@objdump -f $@ | grep "start address"

$(KERNEL_BIN): $(KERNEL_ELF)
	objcopy -O binary $< $@


$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@echo "compilation: $< -> $@"
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(IMG): $(BOOTLOADER) $(KERNEL_BIN)
	@echo "=== img creation ==="
	rm -f $(IMG)
	dd if=/dev/zero of=$(IMG) bs=512 count=2880
	dd if=$(BOOTLOADER) of=$(IMG) conv=notrunc
	dd if=$(KERNEL_BIN) of=$(IMG) bs=512 seek=1 conv=notrunc
	@echo "img: $(IMG)"

run: $(IMG)
	@echo "=== qemu execution  ==="
	$(QEMU) -drive format=raw,file=$(IMG) -s

clean:
	rm -rf $(BUILD)

.PHONY: all run clean
