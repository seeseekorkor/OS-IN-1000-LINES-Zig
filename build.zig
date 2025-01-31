const std = @import("std");

pub fn build(b: *std.Build) void {
    // const whitelist = &[_]Target.Query{
    //     .{ .os_tag = Target.Os.Tag.freestanding }, // freestand환경(OS없이 실행)
    //     .{ .cpu_arch = Target.Cpu.Arch.riscv32 }, // RISC-V 32비트
    // };
    // const target = b.standardTargetOptions(.{ .whitelist = whitelist });
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .riscv32,
        .os_tag = .freestanding,
    });

    const optimize = std.builtin.OptimizeMode.ReleaseFast; // -O2 최적화

    const kernel_mod = b.createModule(.{
        .root_source_file = b.path("src/kernel.zig"),
        .target = target,
        .optimize = optimize,
        .strip = false, // 디버깅 심볼 최대한 포함
        .link_libc = false, // 표준 라이브러리 미사용
    });

    const kernel_exe = b.addExecutable(.{
        .name = "kernel.elf",
        .root_module = kernel_mod,
    });
    // exe.addAssemblyFile(b.path("src/kernel.zig")); // boot 함수 포함
    kernel_exe.setLinkerScript(b.path("src/kernel.ld")); // 링커 스크립트 적용
    kernel_exe.entry = .disabled; // 진입점 제거
    kernel_exe.no_builtin = true; // builtin 함수 미포함?

    b.installArtifact(kernel_exe);
}
