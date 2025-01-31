# OS in 1,000 Lines - Zig
Zig 언어를 사용해 OS in 1,000 Lines를 따라한다.

OS in 1,000 Lines : https://operating-system-in-1000-lines.vercel.app/

## qemu debug
- CPU 레지스터 정보 : ctrl + a -> c -> info registers

## command
- 메모리 주소에 맵핑된 명령어 정보 : llvm-objdump -d kernel.elf
- 레지스터 배치 정보 : llvm-nm kernel.elf