%include "init.inc"

[org 0x10000]
[bits 32]

PM_Start:
  mov bx, SysDataSelector
  mov ds, bx
  mov es, bx
  mov fs, bx
  mov gs, bx
  mov ss, bx
  lea esp, [PM_Start]

  mov edi, 0
  lea esi, [msgPMode]
  call printf

  cld
  mov ax, SysDataSelector
  mov es, ax
  xor eax, eax
  xor ecx, ecx
  mov ax, 256
  mov edi, 0

loop_idt:
  lea esi, [idt_ignore]
  mov cx, 8
  rep movsb
  dec ax
  jnz loop_idt

  lidt [idtr]

  sti
  int 0x77
  jmp $

printf:
  push eax
  push es
  mov ax, VideoSelector
  mov es, ax

printf_loop:
  mov al, byte [esi]
  mov byte [es:edi], al
  inc edi
  mov byte [es:edi], 0x06
  inc esi
  inc edi
  or al, al
  jz printf_end
  jmp printf_loop

printf_end:
  pop es
  pop eax
  ret

msgPMode db "We are in Protected Mode", 0
msg_isr_ignore db "This is an ignorable interrupt", 0

isr_ignore:
  push gs
  push fs
  push es
  push ds
  pushad
  pushfd

  mov ax, VideoSelector
  mov es, ax
  mov edi, (80 * 7 * 2)
  lea esi, [msg_isr_ignore]
  call printf

  popfd
  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

idtr:
  dw 256 * 8
  dd 0

idt_ignore:
  dw isr_ignore
  dw SysCodeSelector
  db 0
  db 0x8E
  dw 0x0001

times 512-($-$$) db 0
