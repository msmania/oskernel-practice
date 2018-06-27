%include "init.inc"

[org 0x10000]
[bits 16]

start:
  cld
  mov ax, cs
  mov ds, ax
  xor ax, ax
  mov ss, ax

  xor ebx, ebx
  lea eax, [tss1]
  add eax, 0x10000
  mov [descriptor4 + 2], ax
  shr eax, 16
  mov [descriptor4 + 4], al
  mov [descriptor4 + 7], ah

  lea eax, [tss2]
  add eax, 0x10000
  mov [descriptor5 + 2], ax
  shr eax, 16
  mov [descriptor5 + 4], al
  mov [descriptor5 + 7], ah

  cli
  lgdt [gdtr]

  mov eax, cr0
  or eax, 0x00000001
  mov cr0, eax

  jmp $ + 2
  nop
  nop
  jmp dword SysCodeSelector:PM_Start

[bits 32]

PM_Start:
  mov bx, SysDataSelector
  mov ds, bx
  mov es, bx
  mov fs, bx
  mov gs, bx
  mov ss, bx
  lea esp, [PM_Start]

  mov ax, TSS1Selector
  ltr ax
  lea eax, [process2]
  mov [tss2_eip], eax
  mov [tss2_esp], esp
  call TSS2Selector:0

  mov edi, 80 * 2 * 9
  lea esi, [msg_process1]
  call printf
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

process2:
  mov edi, 80 * 2 * 7
  lea esi, [msg_process2]
  call printf
  iret

msg_process1 db "This is System Process 1", 0
msg_process2 db "This is System Process 2", 0

gdtr:
  dw gdt_end - gdt
  dd gdt

gdt:
  dd 0, 0
  dd 0x0000FFFF, 0x00CF9A00 ; SysCodeSelector
  dd 0x0000FFFF, 0x00CF9200 ; SysDataSelector
  dd 0x8000FFFF, 0x0040920B ; VideoSelector

descriptor4:  ; TSS1Selector
  dw 104  ; limit 0-15
  dw 0    ; base 0-15
  db 0    ; base 16-23
  db 0x89 ; P=1, DPL=0, Type=9
  db 0    ; G, AVL, Limit 16-19
  db 0    ; base 24-31

descriptor5:  ; TSS2Selector
  dw 104
  dw 0
  db 0
  db 0x89
  db 0
  db 0

gdt_end:

tss1:
  dw 0, 0 ; backlink to a previous task
  dd 0    ; esp0
  dw 0, 0 ; ss0
  dd 0    ; esp1
  dw 0, 0 ; ss1
  dd 0    ; esp2
  dw 0, 0 ; ss2
  dd 0, 0, 0    ; cr3, eip, eflags
  dd 0, 0, 0, 0 ; eax, ecx, edx, ebx
  dd 0, 0, 0, 0 ; esp, ebp, esi, edi
  dw 0, 0 ; es
  dw 0, 0 ; cs
  dw 0, 0 ; ss
  dw 0, 0 ; ds
  dw 0, 0 ; fs
  dw 0, 0 ; gs
  dw 0, 0 ; ldt
  dw 0, 0 ; T bit for debug, IO permit bitmap

tss2:
  dw 0, 0 ; backlink to a previous task
  dd 0    ; esp0
  dw 0, 0 ; ss0
  dd 0    ; esp1
  dw 0, 0 ; ss1
  dd 0    ; esp2
  dw 0, 0 ; ss2
  dd 0    ; cr3
tss2_eip:
  dd 0, 0 ; eip, eflags
  dd 0, 0, 0, 0 ; eax, ecx, edx, ebx
tss2_esp:
  dd 0, 0, 0, 0 ; esp, ebp, esi, edi
  dw SysDataSelector, 0 ; es
  dw SysCodeSelector, 0 ; cs
  dw SysDataSelector, 0 ; ss
  dw SysDataSelector, 0 ; ds
  dw SysDataSelector, 0 ; fs
  dw SysDataSelector, 0 ; gs
  dw 0, 0 ; ldt
  dw 0, 0 ; T bit for debug, IO permit bitmap

times 1024 - ($ - $$) db 0
