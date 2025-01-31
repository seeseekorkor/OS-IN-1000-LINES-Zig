pub extern var __bss: [*]u8; // BSS 시작 주소
pub extern var __bss_end: [*]u8; // BSS 종료 주소
pub extern var __stack_top: [*]u8; // 스택 최상단 주소

pub export fn memset(buf: [*]u8, c: u8, size: u32) void {
    var i: u32 = 0;
    while (i < size) : (i += 1) {
        buf[i] = c;
    }
}

pub export fn kernelMain() void {
    memset(__bss, 0, @intFromPtr(__bss_end) - @intFromPtr(__bss));

    const str_hello = "\n\nHello, world! - sskk\n";
    for (str_hello) |ch| {
        Sbi.putchar(ch);
    }

    while (true) {
        asm volatile ("wfi"); // wait for interrupt
    }
}

// 진입점
pub export fn boot() linksection(".text.boot") callconv(.naked) void {
    asm volatile (
        \\mv sp, %[stack_top]
        \\j kernelMain
        :
        : [stack_top] "r" (&__stack_top), // 입력 레지스터 지정
    );
}

// SBI
pub const Sbi = extern struct {
    pub const Sbiret = extern struct {
        error_code: isize,
        value: isize,
    };

    pub export fn call(arg0: isize, arg1: isize, arg2: isize, arg3: isize, arg4: isize, arg5: isize, fid: isize, eid: isize) Sbiret {
        var a0: isize = arg0;
        var a1: isize = arg1;
        const a2: isize = arg2;
        const a3: isize = arg3;
        const a4: isize = arg4;
        const a5: isize = arg5;
        const a6: isize = fid;
        const a7: isize = eid;

        asm volatile ("ecall"
            : [out_a0] "={a0}" (a0),
              [out_a1] "={a1}" (a1),
            : [in_a0] "{a0}" (a0),
              [in_a1] "{a1}" (a1),
              [in_a2] "{a2}" (a2),
              [in_a3] "{a3}" (a3),
              [in_a4] "{a4}" (a4),
              [in_a5] "{a5}" (a5),
              [in_a6] "{a6}" (a6),
              [in_a7] "{a7}" (a7),
            : "memory", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7" // Clobbers
        );

        return Sbiret{
            .error_code = a0,
            .value = a1,
        };
    }

    pub export fn putchar(ch: u8) void {
        _ = call(ch, 0, 0, 0, 0, 0, 0, 1);
    }
};
