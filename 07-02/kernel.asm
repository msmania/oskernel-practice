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
  times 80 dd 0 ; use as stack space

PM_Start:
  mov bx, SysDataSelector
  mov ds, bx
  mov es, bx
  mov fs, bx
  mov gs, bx
  mov ss, bx
  lea esp, [PM_Start]

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

  mov edi, 8 * 0x20
  lea esi, [idt_timer]
  mov cx, 8
  rep movsb

  mov edi, 8 * 0x21
  lea esi, [idt_keyboard]
  mov cx, 8
  rep movsb

  mov edi, 8 * 0x80
  lea esi, [idt_soft_int]
  mov cx, 8
  rep movsb

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

  mov eax, [CurrentTask]
  add eax, TaskList
  mov ebx, [eax]
  jmp sched

scheduler:
  lea esi, [esp]

  xor eax, eax
  mov eax, [CurrentTask]
  add eax, TaskList

  mov edi, [eax]

  mov ecx, 17

  rep movsd
  add esp, 68

  add dword [CurrentTask], 4
  mov eax, [NumTask]
  mov ebx, [CurrentTask]
  cmp eax, ebx
  jne yet
  mov byte [CurrentTask], 0

yet:
  xor eax, eax
  mov eax, [CurrentTask]
  add eax, TaskList
  mov ebx, [eax]

sched:
  mov [tss_esp0], esp
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

user_process1:
  mov eax, 80 * 2 * 2 + 2 * 5
  lea ebx, [msg_user_process1_1]
  int 0x80
  mov eax, 80 * 2 * 3 + 2 * 5
  lea ebx, [msg_user_process1_2]
  int 0x80
  inc byte [msg_user_process1_2]
  jmp user_process1

msg_user_process1_1 db "User Process1", 0
msg_user_process1_2 db ".I'm running now.", 0

user_process2:
  mov eax, 80 * 2 * 2 + 2 * 35
  lea ebx, [msg_user_process2_1]
  int 0x80
  mov eax, 80 * 2 * 3 + 2 * 35
  lea ebx, [msg_user_process2_2]
  int 0x80
  inc byte [msg_user_process2_2]
  jmp user_process2

msg_user_process2_1 db "User Process2", 0
msg_user_process2_2 db ".I'm running now.", 0

user_process3:
  mov eax, 80 * 2 * 5 + 2 * 5
  lea ebx, [msg_user_process3_1]
  int 0x80
  mov eax, 80 * 2 * 6 + 2 * 5
  lea ebx, [msg_user_process3_2]
  int 0x80
  inc byte [msg_user_process3_2]
  jmp user_process3

msg_user_process3_1 db "User Process3", 0
msg_user_process3_2 db ".I'm running now.", 0

user_process4:
  mov eax, 80 * 2 * 5 + 2 * 35
  lea ebx, [msg_user_process4_1]
  int 0x80
  mov eax, 80 * 2 * 6 + 2 * 35
  lea ebx, [msg_user_process4_2]
  int 0x80
  inc byte [msg_user_process4_2]
  jmp user_process4

msg_user_process4_1 db "User Process4", 0
msg_user_process4_2 db ".I'm running now.", 0

user_process5:
  mov eax, 80 * 2 * 9 + 2 * 5
  lea ebx, [msg_user_process5_1]
  int 0x80
  mov eax, 80 * 2 * 10 + 2 * 5
  lea ebx, [msg_user_process5_2]
  int 0x80
  inc byte [msg_user_process5_2]
  jmp user_process5

msg_user_process5_1 db "User Process5", 0
msg_user_process5_2 db ".I'm running now.", 0

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

times 63 dd 0 ; user-mode stack space
User1Stack:

User1regs:
  dd 0, 0, 0, 0, 0, 0, 0, 0 ; edi, esi, ebp, esp, ebx, edx, ecx, eax
  dw UserDataSelector, 0    ; ds
  dw UserDataSelector, 0    ; es
  dw UserDataSelector, 0    ; fs
  dw UserDataSelector, 0    ; gs
  dd user_process1          ; eip
  dw UserCodeSelector, 0    ; cs
  dd 0x200                  ; eflags
  dd User1Stack             ; esp
  dw UserDataSelector, 0    ; ss

times 63 dd 0 ; user-mode stack space
User2Stack:

User2regs:
  dd 0, 0, 0, 0, 0, 0, 0, 0 ; edi, esi, ebp, esp, ebx, edx, ecx, eax
  dw UserDataSelector, 0    ; ds
  dw UserDataSelector, 0    ; es
  dw UserDataSelector, 0    ; fs
  dw UserDataSelector, 0    ; gs
  dd user_process2          ; eip
  dw UserCodeSelector, 0    ; cs
  dd 0x200                  ; eflags
  dd User2Stack             ; esp
  dw UserDataSelector, 0    ; ss

times 63 dd 0 ; user-mode stack space
User3Stack:

User3regs:
  dd 0, 0, 0, 0, 0, 0, 0, 0 ; edi, esi, ebp, esp, ebx, edx, ecx, eax
  dw UserDataSelector, 0    ; ds
  dw UserDataSelector, 0    ; es
  dw UserDataSelector, 0    ; fs
  dw UserDataSelector, 0    ; gs
  dd user_process3          ; eip
  dw UserCodeSelector, 0    ; cs
  dd 0x200                  ; eflags
  dd User3Stack             ; esp
  dw UserDataSelector, 0    ; ss

times 63 dd 0 ; user-mode stack space
User4Stack:

User4regs:
  dd 0, 0, 0, 0, 0, 0, 0, 0 ; edi, esi, ebp, esp, ebx, edx, ecx, eax
  dw UserDataSelector, 0    ; ds
  dw UserDataSelector, 0    ; es
  dw UserDataSelector, 0    ; fs
  dw UserDataSelector, 0    ; gs
  dd user_process4          ; eip
  dw UserCodeSelector, 0    ; cs
  dd 0x200                  ; eflags
  dd User4Stack             ; esp
  dw UserDataSelector, 0    ; ss

times 63 dd 0 ; user-mode stack space
User5Stack:

User5regs:
  dd 0, 0, 0, 0, 0, 0, 0, 0 ; edi, esi, ebp, esp, ebx, edx, ecx, eax
  dw UserDataSelector, 0    ; ds
  dw UserDataSelector, 0    ; es
  dw UserDataSelector, 0    ; fs
  dw UserDataSelector, 0    ; gs
  dd user_process5          ; eip
  dw UserCodeSelector, 0    ; cs
  dd 0x200                  ; eflags
  dd User5Stack             ; esp
  dw UserDataSelector, 0    ; ss

idtr: dw 256 * 8 ; IDT Limit
      dd 0       ; IDT Base

isr_ignore:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov al, 0x20
  out 0x20, al

  mov edi, (80 * 2 * 0)
  lea esi, [msg_isr_ignore]
  call printf
  inc byte [msg_isr_ignore]

  jmp ret_from_int

isr_32_timer:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov al, 0x20
  out 0x20, al

  mov edi, (80 * 2 * 0)
  lea esi, [msg_isr_32_timer]
  call printf
  inc byte [msg_isr_32_timer]

  jmp ret_from_int

isr_33_keyboard:
  push gs
  push fs
  push es
  push ds
  pushad

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  ; retrieve scan code to receive next interruption
  in al, 0x60

  mov al, 0x20
  out 0x20, al

  mov edi, (80 * 2 * 0) + (2 * 35)
  lea esi, [msg_isr_33_keyboard]
  call printf
  inc byte [msg_isr_33_keyboard]

  jmp ret_from_int

isr_128_soft_int:
  push gs
  push fs
  push es
  push ds
  pushad

  mov edi, eax
  lea esi, [ebx]

  mov ax, SysDataSelector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  call printf

  jmp ret_from_int

ret_from_int:
  xor eax, eax
  mov eax, [esp+52]
  and eax, 0x00000003
  xor ebx, ebx
  mov bx, cs
  and ebx, 0x00000003
  cmp eax, ebx
  ja scheduler

  popad
  pop ds
  pop es
  pop fs
  pop gs
  iret

msg_isr_ignore db "This is an ignorable interrupt", 0
msg_isr_32_timer db ".This is the timer interrupt", 0
msg_isr_33_keyboard db ".This is the keyboard interrupt", 0
msg_isr_128_soft_int db ".This is the software interrupt", 0

idt_ignore:
  dw isr_ignore
  dw 0x08
  db 0
  db 0x8E
  dw 0x0001

idt_timer:
  dw isr_32_timer
  dw 0x08
  db 0
  db 0x8E
  dw 0x0001

idt_keyboard:
  dw isr_33_keyboard
  dw 0x08
  db 0
  db 0x8E
  dw 0x0001

idt_soft_int:
  dw isr_128_soft_int
  dw 0x08
  db 0
  db 0xEF
  dw 0x0001

times 3584 - ($ - $$) db 0
