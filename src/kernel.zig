pub extern var __bss: [*]u8; // BSS 시작 주소
pub extern var __bss_end: [*]u8; // BSS 종료 주소
pub extern var __stack_top: [*]u8; // 스택 최상단 주소

pub export fn memset(buf: [*]u8, c: u8, size: u32) void {
    var i = size;
    while (i > 0) : (i -= 1) {
        buf[i] = c;
    }
}

pub export fn kernel_main() void {
    memset(__bss, 0, @intFromPtr(__bss_end) - @intFromPtr(__bss));

    while (true) {}
}

// 진입점
pub export fn boot() linksection(".text.boot") callconv(.naked) void {
    asm volatile (
        \\mv sp, %[stack_top]
        \\j kernel_main
        :
        : [stack_top] "r" (&__stack_top), // 입력 레지스터 지정
    );
}
