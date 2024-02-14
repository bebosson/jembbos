const NULL_DESCRIPTOR: u32 =  0;
const CODE_SEGMENT_DESCRIPTOR: u32 =  0x00CF9A00; // Example value
const DATA_SEGMENT_DESCRIPTOR: u32 =  0x00CF9200; // Example value
const STACK_SEGMENT_DESCRIPTOR: u32 =  0x00CFFA00; // Example value

static mut GDT: [u32;  4] = [
    NULL_DESCRIPTOR,
    CODE_SEGMENT_DESCRIPTOR,
    DATA_SEGMENT_DESCRIPTOR,
    STACK_SEGMENT_DESCRIPTOR,
];

struct GdtPointer {
    limit: u16,
    base: u32,
}

fn load_gdt() {
    let gdt_pointer = GdtPointer {
        limit: (GDT.len() * std::mem::size_of::<u32>() -  1) as u16,
        base: GDT.as_ptr() as u32,
    };

    unsafe {
        asm!(
            "lgdt [{}]",
            in(reg) &gdt_pointer,
            options(nostack),
        );
    }
}

fn set_segments() {
    unsafe {
        asm!(
            "mov ax, {}",
            "mov ds, ax",
            "mov es, ax",
            "mov fs, ax",
            "mov gs, ax",
            "mov ss, ax",
            "jmp   0x08:reload_segments",
            "reload_segments:",
            in("ax") (0x10 <<  3) |  1, // Selector for data segment
        );
    }
}

fn main() {
    load_gdt();
    set_segments();
    // Continue with the rest of your kernel initialization...
}
