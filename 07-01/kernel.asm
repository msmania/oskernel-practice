%include "init.inc"

[org 0x10000]
[bits 16]

start:
  cld
  mov ax, cs
  mov ds, ax
  xor ax, ax
  mov ss, ax

  xor eax, eax
  lea eax, [tss]
  add eax, 0x10000
  mov [descriptor4 + 2], ax
  shr eax, 16
  mov [descriptor4 + 4], al
  mov [descriptor4 + 7], ah

  xor eax, eax
  lea eax, [printf]
  add eax, 0x10000
  mov [descriptor7], ax
  shr eax, 16
  mov [descriptor7 + 6], al
  mov [descriptor7 + 7], ah

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

  mov ax, TSSSelector
  ltr ax

  mov [tss_esp0], esp
  lea eax, [PM_Start - 256]
  mov [tss_esp], eax

  mov ax, UserDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  lea esp, [PM_Start - 256]

  push dword UserDataSelector ; ss
  push esp                    ; esp
  push dword 0x200            ; eflags: IF=1
  push dword UserCodeSelector ; cs
  lea eax, [user_process]
  push eax                    ; eip
  iretd

printf:
  mov ebp, esp
  push es
  push eax
  mov ax, VideoSelector
  mov es, ax
  mov esi, [ebp + 8]
  mov edi, [ebp + 12]

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
  pop eax
  pop es
  ret

user_process:
  mov edi, 80 * 2 * 7
  push edi
  lea eax, [msg_user_parameter1]
  push eax
  call CallGateSelector:0
  jmp $

msg_user_parameter1 db "This is User Parameter1", 0

gdtr:
  dw gdt_end - gdt
  dd gdt

gdt:
  dd 0, 0
  dd 0x0000FFFF, 0x00CF9A00 ; SysCodeSelector
  dd 0x0000FFFF, 0x00CF9200 ; SysDataSelector
  dd 0x8000FFFF, 0x0040920B ; VideoSelector

descriptor4:                ; TSSSelector
  dw 104  ; limit 0-15
  dw 0    ; base 0-15
  db 0    ; base 16-23
  db 0x89 ; P=1, DPL=0, Type=9
  db 0    ; G, AVL, Limit 16-19
  db 0    ; base 24-31

  dd 0x0000FFFF, 0x00FCFA00 ; UserCodeSelector
  dd 0x0000FFFF, 0x00FCF200 ; UserDataSelector

descriptor7:                ; CallGateSelector
  dw 0
  dw SysCodeSelector
  db 0x02 ; 2 parameters
  db 0xEC ; P=1, DPL=3
  db 0
  db 0

gdt_end:

tss:
  dw 0, 0 ; backlink to a previous task
tss_esp0:
  dd 0                    ; esp0
  dw SysDataSelector, 0   ; ss0
  dd 0                    ; esp1
  dw 0, 0                 ; ss1
  dd 0                    ; esp2
  dw 0, 0                 ; ss2
  dd 0                    ; cr3
tss_eip:
  dd 0, 0                 ; eip, eflags
  dd 0, 0, 0, 0           ; eax, ecx, edx, ebx
tss_esp:
  dd 0, 0, 0, 0           ; esp, ebp, esi, edi
  dw 0, 0                 ; es
  dw 0, 0                 ; cs
  dw UserDataSelector, 0  ; ss
  dw 0, 0                 ; ds
  dw 0, 0                 ; fs
  dw 0, 0                 ; gs
  dw 0, 0                 ; ldt
  dw 0, 0                 ; T bit for debug, IO permit bitmap

times 1024 - ($ - $$) db 0
