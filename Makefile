CC=i686-elf-gcc
LD=i686-elf-ld
RUSTC=rustc
NASM=i686-elf-as
QEMU=qemu-system-i386
GRUB= grub-mkrescue
SRC = src
CARGO = cargo build --lib 
TARGET = target/i686-unknown-linux-gnu/debug

all: myos.iso

.SUFFIXES:

.SUFFIXES: .o .rs .asm

.PHONY: clean run fclean

${TARGET}/libkernel.a: ${SRC}/main.rs
	$(CARGO)
#	$(RUSTC) -O --target i686-unknown-linux-gnu --crate-type=lib -o $@ ${SRC}/kernel.rs

boot.o: boot.s
	$(NASM) boot.s -o $@

myos.bin: boot.o ${TARGET}/libkernel.a
	$(CC) -T linker.ld -o $@ -ffreestanding -O2 -nostdlib boot.o ${TARGET}/libkernel.a -lgcc

myos.iso: myos.bin
	./script_grub.sh
	$(GRUB) -o $@ isodir

run: myos.iso
	$(QEMU) -cdrom $<

clean:
	rm -f *.bin *.o

fclean:
	rm -f *.bin *.o *.iso 
