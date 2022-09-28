[bits 64]
; nasm -f bin -o hello_rel.bin hello_rel.asm
; ndisasm -b 64 hello_rel.bin

section .text
  global _start

_start:
  mov	rax, 1          ; write
  mov	rdi, 1          ; stdout
  lea rsi, [rel msg]
  mov	rdx, msg.len
  syscall

  mov	rax, 60         ; exit
  mov	rdi, 0
  syscall

section .data

msg:    db  "Hello!", 10
.len:   equ $ - msg
