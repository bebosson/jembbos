## INSTALL i686-elf-tools-linux

wget https://github.com/lordmilko/i686-elf-tools/releases/download/13.2.0/x86_64-elf-tools-linux.zip ./i686-elf-tools-linux.zip 
unzip ./i686-elf-tools.zip 
sudo ln -s /home/bebosson/code/jembbos/bin/i686-elf-gcc .
sudo apt-get update
sudo apt-get install xorriso

## INSTALL QEMU

wget https://download.qemu.org/qemu-8.2.1.tar.xz
tar xvJf qemu-8.2.1.tar.xz
cd qemu-8.2.1
./configure
make


