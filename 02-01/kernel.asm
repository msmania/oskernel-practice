[org 0]
[bits 16]

start:
  mov ax, cs
  mov ds, ax
  xor ax, ax
  mov ss, ax

  lea esi, [msgKernel]
  mov ax, 0xB800
  mov es, ax
  mov edi, 0
  call printf
  jmp $

printf:
  push eax

printf_loop:
  mov al, byte [esi]
  mov byte [es:edi], al
  or al, al
  jz printf_end
  inc edi
  mov byte [es:edi], 0x06
  inc esi
  inc edi
  jmp printf_loop

printf_end:
  pop eax
  ret

msgKernel db "We are in kernel program", 0
