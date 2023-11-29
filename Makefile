CC=i686-elf-gcc
LD=i686-elf-ld
RUSTC=rustc
NASM=i686-elf-as
QEMU=qemu-system-i386
GRUB= grub-mkrescue

all: myos.iso

.SUFFIXES:

.SUFFIXES: .o .rs .asm

.PHONY: clean run fclean

kernel.o: kernel.rs
	$(RUSTC) -O --target i686-unknown-linux-gnu --crate-type=lib -o $@ kernel.rs

boot.o: boot.s
	$(NASM) boot.s -o $@

myos.bin: boot.o kernel.o
	$(CC) -T linker.ld -o $@ -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

myos.iso: myos.bin
	./script_grub.sh
	$(GRUB) -o $@ isodir

run: myos.iso
	$(QEMU) -cdrom $<

clean:
	rm -f *.bin *.o

fclean:
	rm -f *.bin *.o *.iso 
