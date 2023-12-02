#![no_std] // ne pas lier la bibliothèque standard Rust
//#![cfg_attr(not(test), no_std)]
#![no_main] // désactiver tous les points d'entrée au niveau de Rust

use core::panic::PanicInfo;
//mod vga_buffer;

static HELLO: &[u8] = b"Hello World!";

#[no_mangle]
pub extern "C" fn kernel_main() -> ! {
//    vga_buffer::print_something();
    let vga_buffer = 0xb8000 as *mut u8;

    for (i, &byte) in HELLO.iter().enumerate() {
        unsafe {
            *vga_buffer.offset(i as isize * 2) = byte;
            *vga_buffer.offset(i as isize * 2 + 1) = 0x4;
        }
    }
    loop {}
}

/// Cette fonction est appelée à chaque panic.
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
