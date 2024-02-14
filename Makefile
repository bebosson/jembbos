TARGET = target/i686-unknown-linux-gnu
CC=i686-elf-gcc
NASM=i686-elf-as
QEMU=qemu-system-i386
GRUB= grub-mkrescue
SRC = src
OBJ = obj
COMPRESS =

profile ?= debug
ifeq (${profile}, release)
	CARGO = cargo build --lib --verbose --release
	T_PATH = ${TARGET}/release
	COMPRESS = --compress=xz 
else
	CARGO = cargo build --lib --verbose
	T_PATH = ${TARGET}/debug
endif

all: jembbos.iso

.SUFFIXES: .o .rs .asm

.PHONY: clean run

${TARGET}/libkernel.a:# ${SRC}/main.rs
	$(CARGO)

${OBJ}/boot.o: ${SRC}/boot.s
	mkdir -p obj
	$(NASM) ${SRC}/boot.s -o $@

jembbos.bin: ${OBJ}/boot.o ${TARGET}/libkernel.a
	$(CC) -T arch/x86/linker.ld -o $@ -ffreestanding -O2 -nostdlib \
	${OBJ}/boot.o ${T_PATH}/libkernel.a -lgcc

jembbos.iso: jembbos.bin
	./script_grub.sh
	$(GRUB) ${COMPRESS} -o $@ isodir

run: jembbos.iso
	$(QEMU) -cdrom $<

clean:
	rm -rf isodir obj *.bin *.iso
	cargo clean

re: clean all
