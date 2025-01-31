#!/bin/bash
set -xue

# QEMU 실행 파일 경로
# shell과 같은 디렉토리에 opensbi-riscv32-generic-fw_dynamic.bin 필요
QEMU=qemu-system-riscv32

# QEMU 실행
# -machine virt: virt 머신을 시작합니다. -machine '?' 명령어로 다른 머신 종류를 확인할 수 있습니다.
# -bios default: QEMU가 제공하는 기본 펌웨어(OpenSBI)를 사용합니다.
# -nographic: GUI 없이 QEMU를 실행합니다.
# -serial mon:stdio: QEMU의 표준 입출력을 가상 머신의 시리얼 포트에 연결합니다. mon: 접두사를 붙여 Ctrl+A 이후 C를 눌러 QEMU 모니터로 전환할 수 있습니다.
# --no-reboot: 가상 머신이 크래시되면 재부팅하지 않고 종료합니다(디버깅 시에 편리합니다).
# $QEMU -machine virt -bios default -nographic -serial mon:stdio --no-reboot
$QEMU -machine virt -bios default -nographic -serial mon:stdio --no-reboot -kernel ../zig-out/bin/kernel.elf