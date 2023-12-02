mkdir -p isodir/boot/grub
if grub-file --is-x86-multiboot jembbos.bin; then
  echo multiboot confirmed
else
  echo the file is not multiboot
fi
cp jembbos.bin isodir/boot/jembbos.bin
cp grub.cfg isodir/boot/grub/grub.cfg
