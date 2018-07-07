%include "init.inc"

[org 0xC0000000]
[bits 32]

  mov esp, 0xC0000FFF

%include "idt_setup_code.inc"

  lidt [idtr]

  mov al, 0xFC
  out 0x21, al ; activate timer and keyboard interruption
  sti

  mov ax, TSSSelector
  ltr ax

  mov eax, [CurrentTask]
  add eax, TaskList
  lea edx, [User1regs]
  mov [eax], edx
  add eax, 4
  lea edx, [User2regs]
  mov [eax], edx
  add eax, 4
  lea edx, [User3regs]
  mov [eax], edx
  add eax, 4
  lea edx, [User4regs]
  mov [eax], edx
  add eax, 4
  lea edx, [User5regs]
  mov [eax], edx

yet:
  mov eax, [CurrentTask]
  add eax, TaskList
  mov ebx, [eax]
  jmp sched

scheduler:
  mov eax, [CurrentTask]
  add eax, TaskList
  mov edi, [eax]
  lea esi, [esp]
  mov ecx, 17
  rep movsd
  add esp, 68

  add dword [CurrentTask], 4
  mov eax, [NumTask]
  mov ebx, [CurrentTask]
  cmp eax, ebx
  jne yet
  mov byte [CurrentTask], 0
  jmp yet

sched:
  mov eax, [TSS_ESP0_WHERE]
  mov [eax], esp
  lea esp, [ebx]
  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

CurrentTask dd 0
NumTask dd 20
TaskList: times 5 dd 0

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

%include "user_task_structure.inc"
%include "isr.inc"

idtr: dw 256 * 8  ; IDT Limit
      dd IDT_BASE ; IDT Base

%include "idt.inc"

times 512 * 7 - ($ - $$) db 0
