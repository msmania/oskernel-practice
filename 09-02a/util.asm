[bits 32]

[global Launcher]

segment .text
extern thunk

Launcher:
  mov eax, eax
  call 0x2
  nop
  call far thunk
  call thunk
  nop
  nop
  call 8:thunk
  nop
  ret
